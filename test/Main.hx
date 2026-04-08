package;

import ale.rulescript.*;

class Main
{
    public static function main()
    {
        RuleScriptGlobal.apply();

        final script:RuleScript = new RuleScript('oso');
        script.run();
    }
}