buildするには、
buildlib以下に２つファイルを追加する必要があります。

・flex-messaging.jar
・flex-messaging-common.jar

いづれもFlex Data Services 2に付属のファイルになります。
デフォルトアプリケーションである、flex.warの中にあります。

flex/WEB-INF/lib/flex-messaging.jar
flex/WEB-INF/lib/flex-messaging-common.jar

上記のファイルをコピーしてコンパイルしてください。


mvnで使用するときには、
flex-messageing.jar
flex-messaging-common.jar
をmvnのローカルリポジトリにインストールします。

mvn install:install-file -Dfile="${workspaceフルパス}\fds-s2factory/buildlib/flex-messaging.jar" -DgroupId=com.adobe.flex2 -DartifactId=flex-messaging -Dversion=2.0.0 -Dpackaging=jar
mvn install:install-file -Dfile="${workspaceフルパス}\fds-s2factory/buildlib/flex-messaging-common.jar" -DgroupId=com.adobe.flex2 -DartifactId=flex-messaging-common -Dversion=2.0.0 -Dpackaging=jar

