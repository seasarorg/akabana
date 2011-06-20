/*
 * Copyright 2004-2009 the Seasar Foundation and the Others.
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
    
    import org.seasar.akabana.yui.command.core.EventListener;
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

        private var _completeEventListener:EventListener;
        
        private var _errorEventListener:EventListener;

        protected var _name:String;
        
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
         * コマンドの名前を指定
         * 
         * @param value 名前
         * 
         */
        public function name(value:String):ICommand {
            _name = value;
            return this;
        }
        
        /**
         * 
         * @param args
         * 
         */
        public function start( ...args ):ICommand{
            try{
                ( this.run as Function ).apply( null, args );
            }catch( e:Error ){
                failed(e);
            }
            return this;
        }

        /**
         * 
         * @param args
         * 
         */
        public function stop(...args):void{
            throw new Error( "no implements" );
        }
        
        /**
         * 
         * @param handler
         * @return 
         * 
         */
        public function complete( handler:Function ):ICommand{
            if( handler == null ){
                if( _completeEventListener.handler != null ){
                    removeEventListener( CommandEvent.COMPLETE, _completeEventListener.handler, false );
                }                
            } else {
                _completeEventListener.handler = handler;
                addEventListener( CommandEvent.COMPLETE, handler, false, int.MAX_VALUE, true );
            }
            return this;
        }
        
        /**
         * 
         * @param handler
         * @return 
         * 
         */
        public function error( handler:Function ):ICommand{
            if( handler == null ){
                if( _errorEventListener.handler != null ){
                    removeEventListener( CommandEvent.ERROR,_errorEventListener.handler, false );
                }                
            } else {
                _errorEventListener.handler = handler;
                addEventListener( CommandEvent.ERROR, handler, false, int.MAX_VALUE, true );
            }
            return this;
        }
        
        /**
         * 
         * @param handler
         * @return 
         * 
         */
        public function listener( listenerObj:Object ):ICommand{
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
                    _completeEventListener.handler = completeFuncDef.getFunction(listenerObj);
                }
                if( errorFuncDef != null ){
                    _errorEventListener.handler = errorFuncDef.getFunction(listenerObj);
                }
            }
            return this;
        }
        
        /**
         * 
         * @param value
         * 
         */
        public function done( value:Object = null ):void{
            dispatchEvent( CommandEvent.createCompleteEvent( this, value ) );
        } 
        
        /**
         * 
         * @param message
         * 
         */
        public function failed( message:Object = null ):void{
            dispatchEvent( CommandEvent.createErrorEvent( this, message ) );
        }

        /**
         * 
         * @param args
         * 
         */
        protected function run( ...args ):void{
            throw new Error( "no implements" );
        }     
    }
}