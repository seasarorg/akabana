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
package org.seasar.akabana.yui.command
{
    /**
     * 複合コマンド定義インターフェイス
     * 
     */
    public interface ComplexCommand extends Command
    {
        /**
         * コマンドを追加する
         * 
         * @param command コマンド
         * @return 複合コマンド
         * 
         */
        function addCommand( command:Command ):ComplexCommand;
        
        /**
         * コマンドを名前付きで追加する
         * 
         * @param name
         * @param command コマンド
         * @return 複合コマンド
         * 
         */
        function addNamedCommand( name:String, command:Command ):ComplexCommand;
        
        /**
         * 名前よりコマンドを取得する
         * 
         * @param name コマンド名
         * @return 複合コマンド
         * 
         */
        function getCommandByName( name:String ):Command;
        
        /**
         * 子コマンドのイベント完了リスナーを設定する
         * 
         * @param handler イベント完了ハンドラ
         * @return 複合コマンド
         * 
         */
        function setChildCompleteEventListener( handler:Function ):ComplexCommand;
    }
}