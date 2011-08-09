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
package org.seasar.akabana.yui.command.core
{
    /**
     * コマンド定義インターフェイス
     *  
     * 
     */
    public interface ICommand {

        /**
         * コマンドの結果があるか
         * 
         */
        function get hasResult():Boolean;
        
        /**
         * コマンドの結果
         * 
         */
        function get result():Object;
        
        /**
         * コマンドのエラーステータスがあるか
         * 
         */
        function get hasStatus():Boolean;
        
        /**
         * コマンドのエラーステータス
         * 
         */
        function get status():Object;
        
        /**
         * コマンドの名前を指定
         * 
         * @param value 名前
         * 
         */
        function name(value:String):ICommand;
        
        /**
         * コマンドの引数を指定
         * 
         * @param value 名前
         * 
         */
        function arguments(...args):ICommand;
        
        /**
         * コマンドを開始する
         * 
         * @param args コマンド引数
         * 
         */
        function start(...args):ICommand;

        /**
         * コマンドを停止する
         * 
         */        
        function stop():void;
        
        /**
         * コマンド完了イベントリスナーを設定する
         * 
         * @param handler コマンド完了イベントハンドラ
         * @return コマンド
         * 
         */
        function complete(handler:Function):ICommand;

        /**
         * コマンドエラーイベントリスナーを設定する
         * 
         * @param handler コマンドエラーイベントハンドラ
         * @return コマンド
         * 
         */
        function error(handler:Function):ICommand;

        /**
         * コマンドイベントリスナーを設定する
         * 
         * @param listener コマンドイベントリスナー
         * @return コマンド
         * 
         */
        function listener(listenerObj:Object):ICommand;

    }
}