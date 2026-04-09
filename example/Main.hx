package;

import ale.rulescript.RuleScriptGlobal;
import ale.rulescript.RuleScript;

import haxe.Exception;

class Main
{
    public static function main()
    {
        /**
         * This initializes/resets the `RuleScriptGlobal` variables
         * This MUST ALWAYS be done before using the `RuleScript` from this library
         */
        
        RuleScriptGlobal.reset();

        /**
         * After initializing the variables
         * You can start customizing the ones you might not be entirely satisfied with
         * If you've changed the default settings but then want to revert to them
         * You can use the settings available in `RuleScriptPresets`
         */

        RuleScriptGlobal.MODULE_PATH = 'customModulesPath/';
        RuleScriptGlobal.SCRIPT_PATH = 'customScriptsPath/';

        RuleScriptGlobal.ERROR_HANDLER = (error:Dynamic) -> trace('Custom Error Handler: ' + error);

        /**
         * After initializing the variables and customizing them to your liking
         * You must run this function to apply the changes to the library
         */

        RuleScriptGlobal.apply();

        /**
         * After completing the steps above
         * You can start using the `RuleScript` from this library
         */

        final script:RuleScript = new RuleScript('script');

        script.set('externVariable', 'Extern Variable');

        final scriptResult = script.run();

        script.call('scriptCall');
        script.call('scriptCall', ['oso']);

        trace(scriptResult);
    }
}