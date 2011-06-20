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
package org.seasar.akabana.yui.command.core
{
    /**
     * 複合コマンド定義インターフェイス
     * 
     */
    public interface ComplexCommand extends ICommand
    {
        /**
         * コマンドを追加する
         * 
         * @param command コマンド
         * @param name コマンド名
         * @return 複合コマンド
         * 
         */
        function add( command:ICommand, name:String=null ):ComplexCommand;
        
        /**
         * 名前よりコマンドを取得する
         * 
         * @param name コマンド名
         * @return 複合コマンド
         * 
         */
        function fetch( name:String ):ICommand;
        
        /**
         * 子コマンドのイベント完了リスナーを設定する
         * 
         * @param handler イベント完了ハンドラ
         * @return 複合コマンド
         * 
         */
        function childComplete( handler:Function ):ComplexCommand;

        /**
         * 子コマンドのイベントエラーリスナーを設定する
         * 
         * @param handler イベントエラーハンドラ
         * @return 複合コマンド
         * 
         */
        function childError( handler:Function ):ComplexCommand;        
    }
}