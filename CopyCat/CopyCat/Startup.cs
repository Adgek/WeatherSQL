using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(CopyCat.Startup))]
namespace CopyCat
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
