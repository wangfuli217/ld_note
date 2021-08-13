using System;
using System.Web;

namespace Com.Everunion.Util
{
    public class FrontPage : System.Web.UI.Page 
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ChkUserLogin();
        }

        protected void ChkUserLogin()
        {
            if (SessionUtil.getWebUser(Session) == null)
            {
                Response.Redirect("/user/login.aspx?burl=" + Server.UrlEncode(Request.Url.ToString())); 
                return;
            }
        }
    }
}
