package lightsHal

import (
	"android/soong/android"
	"android/soong/cc"
)

func init() {
	android.RegisterModuleType("lightsHal_defaults", lightsHalDefaultsFactory)
}

func lightsHalDefaultsFactory() android.Module {
	module := cc.DefaultsFactory()
	android.AddLoadHook(module, lightsHaldefaults)
	return module
}

func lightsHaldefaults(ctx android.LoadHookContext) {
	type props struct {
		Cflags []string
	}
	var useWhiteOnly = ctx.Config().Getenv("TARGET_LED_WHITE_ONLY")
	if useWhiteOnly != "" {
		props := struct {
			Cflags []string
		}{}
		props.Cflags = append(props.Cflags, "\"-DWHITE_ONLY\"")
		ctx.AppendProperties(props)
	}
}
