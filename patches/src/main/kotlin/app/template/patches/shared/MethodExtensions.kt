package app.template.patches.shared

import app.morphe.patcher.patch.PatchException
import app.morphe.patcher.util.proxy.mutableTypes.MutableMethod
import com.android.tools.smali.dexlib2.builder.MutableMethodImplementation
import java.lang.reflect.Field

/**
 * `MutableMethodImplementation.registerCount` is a `final int`. Growing it is
 * required when injecting smali code that needs scratch registers beyond the
 * method's existing locals.
 *
 * This helper bumps the field via reflection so subsequent `addInstructions`
 * calls compile against the new register count (the inline-smali compiler reads
 * `method.implementation.registerCount` to set `.registers N` in its template).
 *
 * Note: smali parameter notation `p0..pN` is RELATIVE to register count — it
 * always refers to the LAST `parameterCount + 1` registers. Growing register
 * count automatically remaps `p0` to a higher v-register, so existing parameter
 * references stay correct.
 */
fun MutableMethod.ensureRegisters(needed: Int) {
    val impl = implementation ?: return
    if (impl.registerCount >= needed) return

    val field = registerCountField
        ?: throw PatchException(
            "MutableMethodImplementation has no `int` field named 'registerCount' " +
                "(scanned all declared fields). dexlib2 internal layout changed?",
        )
    field.setInt(impl, needed)
}

// Resolve the private field once at class-load time by scanning structure rather
// than hard-coding a name. Survives dexlib2 / morphe-smali renames as long as the
// field type stays `int`. The declaredFields scan yields stable ordering so
// caching the result is safe.
private val registerCountField: Field? = run {
    MutableMethodImplementation::class.java.declaredFields
        .firstOrNull { it.type == Int::class.javaPrimitiveType }
        ?.apply { isAccessible = true }
}
