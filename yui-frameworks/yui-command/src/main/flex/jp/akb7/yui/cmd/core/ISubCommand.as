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
package jp.akb7.yui.cmd.core
{
    /**
     * サブコマンド定義インターフェイス
     * 
     * 複合コマンドに依存するコマンドを示すインターフェイスです。
     * 
     */
    public interface ISubCommand extends ICommand {

        /**
         * 親となる複合コマンドを取得する。
         * 
         * @return 複合コマンド
         * 
         */
        function get parent():IComplexCommand;
        
        /**
         * 親となる複合コマンドを設定する。
         * 
         * @param value 複合コマンド
         * 
         */
        function set parent( value:IComplexCommand ):void;
    }
}