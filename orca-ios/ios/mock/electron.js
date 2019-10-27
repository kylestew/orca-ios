export let remote = {
    app: {
        menu: [],
        injectMenu(menu) {
            self.menu = menu;
            window.webkit.messageHandlers.menuDidUpdate.postMessage(JSON.stringify(menu));
        },
        invokeMenuItem(submenu, item)  {
            var result = menu.filter(obj => {
                return obj.label === submenu;
            });
            var sub = result[0].submenu.filter(obj => {
                return obj.label === item;
            });
            let menuItem = sub[0];

            menuItem.click(menuItem, {
                           webContents: {
                           focus() {}
                           }
                           });
        }
    }
}
