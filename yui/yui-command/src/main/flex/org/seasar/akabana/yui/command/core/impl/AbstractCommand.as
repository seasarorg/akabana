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
    import flash.events.EventDispatcher;
    
    import org.seasar.akabana.yui.command.core.Command;
    import org.seasar.akabana.yui.command.core.EventListener;
    import org.seasar.akabana.yui.command.events.CommandEvent;

    /**
     * 
     * 
     */
    public class AbstractCommand extends EventDispatcher implements Command {

        private var _completeEventListener:EventListener;
        
        private var _errorEventListener:EventListener;

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
        public function start( ...args ):Command{
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
        public function complete( handler:Function ):Command{
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
        public function error( handler:Function ):Command{
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