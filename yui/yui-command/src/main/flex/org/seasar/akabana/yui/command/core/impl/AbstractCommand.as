/*
 * Copyright 2004-2011 the Seasar Foundation and the Others.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */
package org.seasar.akabana.yui.command.core.impl
{
    import flash.errors.IllegalOperationError;
    import flash.events.EventDispatcher;
    
    import org.seasar.akabana.yui.command.core.ICommand;
    import org.seasar.akabana.yui.command.events.CommandEvent;
    import org.seasar.akabana.yui.core.ns.handler;
    import org.seasar.akabana.yui.core.reflection.ClassRef;
    import org.seasar.akabana.yui.core.reflection.FunctionRef;
    import org.seasar.akabana.yui.util.StringUtil;

    /**
     * 
     * 
     */
    public class AbstractCommand extends EventDispatcher implements ICommand {

        protected var _completeEventListener:EventListener;
        
        protected var _errorEventListener:EventListener;

        protected var _name:String;
        
        /**
         * コマンドの名前を指定
         * 
         * @param value 名前
         * 
         */
        public final function get name():String{
            return _name;
        }
                
        public final function set name(value:String):void{
            _name = value;
        }
        
        protected var _arguments:Array = [];
        
        /**
         * コマンドの引数を指定
         * 
         * @param value 名前
         * 
         */
        public final function get arguments():Array{
            return _arguments;
        }
        
        public final function set arguments(...args):void{
            _arguments = args;
        }
        
        private var _hasResult:Boolean;
        
        public final function get hasResult():Boolean{
            return _hasResult;
        }
        
        private var _result:Object;

        public final function get result():Object{
            return _result;
        }

        public final function set result(value:Object):void{
            _result = value;
            _hasResult = true;
        }
        
        private var _hasStatus:Boolean;
        
        public final function get hasStatus():Boolean{
            return _hasStatus;
        }
        
        private var _status:Object;
        
        public final function get status():Object{
            return _status;
        }
        
        public final function set status(value:Object):void{
            _status = value;
            _hasStatus = true;
        }
        
        /**
         * 
         * 
         */
        public function AbstractCommand(){
            super();
            _completeEventListener = new EventListener();
            _errorEventListener = new EventListener();
        }
        
        /**
         * 
         * @param args
         * 
         */
        public final function start( ...args ):ICommand{
            _arguments = args;
            try{
                run();
                done();
            }catch( e:Error ){
                status = e;
                failed();
            }
            return this;
        }

        /**
         * 
         * @param args
         * 
         */
        public final function stop():void{
            _completeEventListener.clear();
            _errorEventListener.clear();
        }
        
        /**
         * 
         * @param handler
         * @return 
         * 
         */
        public final function complete( handler:Function ):ICommand{
            if( _completeEventListener.handler != null ){
                removeEventListener( CommandEvent.COMPLETE, _completeEventListener.handler, false );
            }
            if( handler != null ){
                _completeEventListener.handler = handler;
                addEventListener( CommandEvent.COMPLETE, _completeEventListener.handler, false, int.MAX_VALUE, true );
            }
            return this;
        }
        
        /**
         * 
         * @param handler
         * @return 
         * 
         */
        public final function error( handler:Function ):ICommand{
            if( _errorEventListener.handler != null ){
                removeEventListener( CommandEvent.ERROR,_errorEventListener.handler, false );
            }
            if( handler != null ){
                _errorEventListener.handler = handler;
                addEventListener( CommandEvent.ERROR, _errorEventListener.handler, false, int.MAX_VALUE, true );
            }
            return this;
        }
        
        /**
         * 
         * @param handler
         * @return 
         * 
         */
        public final function listener( listenerObj:Object ):ICommand{
            if( _name == null ){
                throw new IllegalOperationError(this+" is no name.");
            }
            if( listenerObj != null ){
                if( _errorEventListener.handler != null ){
                    removeEventListener( CommandEvent.ERROR,_errorEventListener.handler, false );
                }
                if( _completeEventListener.handler != null ){
                    removeEventListener( CommandEvent.COMPLETE, _completeEventListener.handler, false );
                }
                
                const classRef:ClassRef = getClassRef(listenerObj);
                const completeMethod:String = _name + "_" + CommandEvent.COMPLETE;
                const errorMethod:String = _name + "_" + CommandEvent.ERROR;
                
                const ns:Namespace = org.seasar.akabana.yui.core.ns.handler;
                const completeFuncDef:FunctionRef = classRef.getFunctionRef( completeMethod, ns );
                const errorFuncDef:FunctionRef = classRef.getFunctionRef( errorMethod, ns );

                if( completeFuncDef != null ){
                    complete(completeFuncDef.getFunction(listenerObj));
                }
                if( errorFuncDef != null ){
                    error(errorFuncDef.getFunction(listenerObj));
                }
            }
            return this;
        }
        
        /**
         * 
         * @param value
         * 
         */
        protected function done():void{
            dispatchEvent( CommandEvent.createCompleteEvent( this, result ) );
            stop();
        } 
        
        /**
         * 
         * @param message
         * 
         */
        protected final function failed():void{
            dispatchEvent( CommandEvent.createErrorEvent( this, status ) );
            stop();
        }

        /**
         * 
         */
        protected function run():void{
        }
    }
}