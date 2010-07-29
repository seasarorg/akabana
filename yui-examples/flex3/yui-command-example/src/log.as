package
{
    import flash.utils.getTimer;
    
    public function log(...args):void{
        var traceFunction:Function = trace;
        traceFunction.apply(null,["["+getTimer()+"]"].concat(args));
    }
}