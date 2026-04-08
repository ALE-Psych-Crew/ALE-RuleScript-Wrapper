package;

trace(externVariable);

final scriptInstance:ScriptClass = new ScriptClass('My Scripted Class');
scriptInstance.main();

function scriptCall(?arg:String = 'Default Arg')
{
    trace('Script Call: ' + arg);
}

return 'Script Result';