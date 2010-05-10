package org.seasar.akabana.yui.core.error
{
    import mx.resources.ResourceManager;

    import org.seasar.akabana.yui.util.StringUtil;

    [ResourceBundle("yui_core")]
    public class NotFoundError extends Error
    {
        public function NotFoundError(owner:Object,target:String)
        {
            var ownerName:String;
            if( owner is String ){
                ownerName = owner as String;
            } else {
                ownerName = getClassRef(owner).className;
            }
            super(
                StringUtil
                    .substitute(
                        ResourceManager.getInstance().getString("yui_core","NOT_FOUND_ERROR"),
                        ownerName,
                        target
                    )
            );

        }

    }
}