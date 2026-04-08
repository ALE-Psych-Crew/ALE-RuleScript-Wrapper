package;

class ScriptClass
{
    public final text:String;

    public function new(text:String)
    {
        this.text = text;
    }

    public function main()
    {
        trace(text);
    }
}