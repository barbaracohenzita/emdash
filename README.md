:root
{
     --font-size-h1:                  30px;
     --font-size-h2:                  23px;
     --font-size-h3:                  22px;
     --font-size-h4:                  19px;
     --font-size-h5:                  18px;
     --font-size-h6:                  17px;
     --font-family-editor:            Avenir, Avenir Next, sans-serif;
     --font-family-preview:           Avenir, Avenir Next, sans-serif;
}

/* obsdn dark rmx - v202008071640 */


body{

    font-size: 18px;
    font-family: Barlow, Cairo, Inter, sans-serif;
    --font-monospace: 'Fira Code', Source Code Pro, monospace;
}


/* ======= DARK ==============*/
.theme-light,
.theme-dark {
    --color:20, 60%;/*两个值一样*/
    --l:55%; /*最小值50*/
    --color-primary-lightest: hsl(var(--color),var(--l));
    --color-primary-light: hsl(var(--color),calc(var(--l) - 7.5%));
    --color-primary: hsl(var(--color),calc(var(--l) - 8%));
    --color-primary-dark: hsl(var(--color),calc(var(--l) - 15%));
    --color-primary-middark: hsl(var(--color),calc(var(--l) - 20%));
    --color-primary-darkest: hsl(var(--color),calc(var(--l) - 29%));
    --color-text-dark:hsl(var(--color),calc(var(--l) - 40%));
    --color-text-darkest:hsl(var(--color),calc(var(--l) - 50%));     

    --background-primary: var(--color-primary-dark);
    --background-modifier-border: #303030;
    --background-primary-alt: #171717;
    --background-secondary: var(--color-primary-dark);
    --background-secondary-alt: var(--color-primary-dark);
    --background-modifier-box-shadow: rgba(0, 0, 0, 0.85);
    --text-accent: var(--color-primary-dark);
    --text-accent-hover: #2b60af;/*深蓝色*/
    --text-normal: #000000;
    --text-muted: #232323;
    --text-faint: #232323;
    --text-error: #ff3333;
    --text-error-hover: #990000;
    --text-matched: #7dff8f;
    --text-on-accent: #dcddde;
    --text-selection: rgba(6, 66, 113, 0.99);
    --text-highlight-bg: var(--color-primary-lightest);
    --interactive-normal: #2a2a2a;
    --interactive-hover: #303030;
    --interactive-accent: rgb(0, 0, 0);/*浅蓝色*/
    --interactive-accent-rgb: 32, 171, 233;
    --interactive-accent-hover: #1da3d6;/*浅蓝色*/
    --scrollbar-active-thumb-bg: var(--color-primary-darkes);
    --scrollbar-bg: rgba(255, 255, 255, 0);
    --scrollbar-thumb-bg: var(--color-primary-dark);
    --accent-strong: #ec0d0d;
    --text-title-h1:              #000000;
    --text-title-h2:              #000000;
    --text-title-h3:              #000000;
    --text-title-h4:              #000000;
    --text-title-h5:              #000000;
    --text-title-h6:              #000000;
}


/* ======= LIGHT==============*/
/*
.theme-light {
    --background-primary: #ffffff;
    --background-primary-alt: #f0f2f5;
    --background-secondary: #f2f3f5;
    --background-secondary-alt: #e3e5e8;
    --background-accent: #fff;
    --background-modifier-border: #ddd;
    --background-modifier-form-field: #fff;
    --background-modifier-form-field-highlighted: #fff;
    --background-modifier-box-shadow: rgba(0, 0, 0, 0.1);
    --background-modifier-success: #A4E7C3;
    --background-modifier-error: #e68787;
    --background-modifier-error-rgb: 230, 135, 135;
    --background-modifier-error-hover: #FF9494;
    --background-modifier-cover: rgba(0, 0, 0, 0.8);
    --text-accent: #3e93d8;
    --text-accent-hover: #2b60af;
    --text-normal: #dcddde;
    --text-muted: #999;
    --text-faint: #666;
    --text-error: #ff3333;
    --text-error-hover: #990000;
    --text-highlight-bg: rgba(240, 255, 82, 0.76);
    --text-selection: rgba(134, 202, 255, 0.99);
    --text-on-accent: #f2f2f2;
    --text-matched: #000000;
    --interactive-normal: #f2f3f5;
    --interactive-hover: #e9e9e9;
    --interactive-accent: rgb(34, 182, 226);
    --interactive-accent-rgb: 34, 182, 226;
    --interactive-accent-hover: #1da3d6;
    --scrollbar-active-thumb-bg: rgb(97, 170, 221);
    --scrollbar-bg: rgba(0, 0, 0, 0);
    --scrollbar-thumb-bg: rgb(0, 0, 0);
    --accent-strong: #ff3333;
}
*/

/* code block remove shadow */

.theme-light code[class*="language-"],
.theme-light pre[class*="language-"] {
    background: var(--background-primary-alt);
    text-shadow: 0px 0px white;
    font-family: var(--font-monospace);
    text-align: left;
    white-space: pre;
    word-spacing: normal;
    word-break: normal;
    word-wrap: normal;
    line-height: 1.5;
}


/* code block:remove white bg on operators */

.theme-light .token.operator {
    background: hsla(0, 0%, 100%, 0);
}


/* ====== Tag Pills ======== */

.tag {
    background-color: var(--text-accent);
    border: none;
    color: var(--color-text-darkest);
    font-size: 14px;
    padding: 0px 9px 0px;
    text-align: center;
    text-decoration: none !important;
    display: inline-block;
    margin: 5px 5px;
    cursor: pointer;
    border-radius: 2px;
    box-shadow:-5px -3px 8px var(--color-primary),
    6px 2px 12px var(--color-primary-darkest);
}

.tag:hover {
    background-color: var(--color-primary-darkest);
    color: #d1c0ff;
}

.tag[href^="#链接"]:hover {
    color: #ac8fff;
}

.tag[href^="#重要"]:hover {
    color: #ff9d9d;
}

.tag[href^="#已完成"]:hover {
    color: #c3ffae;
}

.tag[href^="#待完成"]:hover {
    color: #8ffff2;
}
.tag:active
{
	background-color: var(--color-primary-dark);
    box-shadow:inset 0px 0px 0px var(--color-primary),
    inset 0px 0px 0px var(--color-primary-darkest);
}

/*=== trace indentation lines by death_au === */

.cm-hmd-list-indent .cm-tab,
ul ul {
    position: relative;
}

.cm-hmd-list-indent .cm-tab::before,
ul ul::before {
    content: '';
    border-left: 2px solid var(--background-modifier-border);
    /*rgba(20,122,255,0.3);
*/
    position: absolute;
}

.cm-hmd-list-indent .cm-tab::before {
    left: 0;
    top: -5px;
    bottom: -4px;
}

ul ul::before {
    left: -15px;
    top: 0;
    bottom: 0;
}


/*==============TRANSCLUSION TWEAKS=============*/

.markdown-embed-title {
    font-family: sans-serif;
    font-size: 25px;
    color: var(--color-text-darkest);
    /*rgb(150,200,255);
*/
    line-height: 35px;
    width: 100%;
    text-align: center;
    font-weight: 100;
    margin: 0px 0px;
    box-shadow:-5px -3px 8px var(--color-primary),
    6px 2px 12px var(--color-primary-darkest);
}
.markdown-embed-title:hover{
  background-color: var(--color-primary-darkest);
  color: #c3ffae;
}
.markdown-embed-title:active{

    box-shadow:0px 0px 0px var(--color-primary),
    0px 0px 0px var(--color-primary-darkest);
}

.markdown-preview-view .markdown-embed {
    background-color: var(--color-primary-dark);
    border-radius: 0px;
    border: 0;
    border-left: 1px solid var(--color-text-darkest);
    margin: 0px -20px;
}

.markdown-embed {
    display: block;
    top: 0px;
}

.markdown-embed>.markdown-embed-content {
    display: inline;
    max-height: 100%;
    max-width: 100%;
    margin: 0px 0px -15px 0px;
    padding: 0px 0px 5px 0px;
}

.markdown-embed-content>* {
    display: block;
    max-height: 100%;
    max-width: 100%;
    margin: 20px 0px 20px 0px;
}

.markdown-embed-link {
    top: -3px;
    left: -20px;
    width: 5px;
    color: var(--color-text-darkest);
    cursor: pointer;
    position: absolute;
}
.markdown-preview-view .markdown-embed-content p:first-child {
    margin-top: 50px;
}
svg.link {
    width: 12px;
    height: 12px;
}

.file-embed-link {
    top: 10px;
    left: -10px;
    color: var(--accent-strong);
    cursor: pointer;
    position: relative;
}

.internal-embed,
.internal-embed>.markdown-embed>.markdown-embed-content {
    display: block;
    max-height: 100%;
    max-width: 100%;
    left: 0px;
}

/*============================================link 的写法===========================================*/
.document-search-container {
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    height: 40px;
    background-color: var(--color-primary-dark);
    display: flex;
    flex-direction: column;
    padding: 5px;
    z-index: var(--layer-popover);
    border-top: 1px solid var(--background-secondary);
}
input.document-search-input, input.document-replace-input {
    border: none;
    flex-grow: 1;
    height: 28px;
    margin: 1px 10px;
    box-shadow: -5px -3px 10px var(--color-primary),
    6px 2px 12px var(--color-primary-darkest);
}
.document-search-button {
    height: 26px;
    font-size: 14px;
    padding: 0 6px;
    color: var(--text-muted);
    margin: 2px 5px;
    background-color: var(--color-primary-dark);
    box-shadow: -5px -3px 10px var(--color-primary),
    6px 2px 12px var(--color-primary-darkest);
}
.document-search-button:hover {
	background-color: var(--color-text-dark);
	color: #c7254e;
}
.document-search-button:active {
	background-color: var(--color-primary-dark);
	color: #c7254e;
    box-shadow: 0px 0px 0px var(--color-primary),
    0px 0px 0px var(--color-primary-darkest);
}
.vertical-tab-nav-item {
    border-left: 3px solid transparent;
    user-select: none;
    cursor: pointer;
    width: 182px;
}
.modal.mod-settings .vertical-tab-content-container {
    padding: 35px 0px 20px 0;
    height: 70vh;
    color: transparent;
    background-color: #ffffff00;
}

.workspace-tab-container-before.is-before-active .workspace-tab-header-inner, .workspace-tab-header.is-before-active .workspace-tab-header-inner {
    height: 100%;
    display: flex;
    border-radius: 5px;
}


.cm-s-obsidian span.cm-inline-code {
    color: #c7254e;
    font-size: 90%;
    background-color: var(--color-text-dark);
    vertical-align: baseline;
}
.cm-s-obsidian span.cm-inline-code:not(.cm-formatting):not(.cm-hmd-indented-code):not(.obsidian-search-match-highlight) {
  background-color: var(--color-text-dark);
  vertical-align: baseline;
  border-radius: 0px;

}

.markdown-preview-view code{
	background-color:var(--color-text-dark);
}

.external-link{
	color:var(--color-text-darkest);
}


.CodeMirror-vscrollbar {
    outline: 0;
    right: 0;
    top: 0;
    overflow-x: hidden;
    overflow-y: scroll;
}
.menu {
    background-color: var(--background-primary);
    border-radius: 4px;
    border: 1px solid var(--background-modifier-border);
    box-shadow: -5px -3px 10px var(--color-primary),
    6px 2px 12px var(--color-primary-darkest);
    position: absolute;
    z-index: var(--layer-menu);
    user-select: none;
}

.menu-item:hover {
  background-color: var(--color-text-dark);
}

.markdown-preview-view .internal-link {
  text-decoration: underline;
  text-decoration-style: initial;
  text-decoration-color: #00000000;
  cursor: pointer;
  color:var(--color-text-dark);
  border-radius: 3px;
  box-shadow:-5px -3px 5px var(--color-primary),
    6px 2px 9px var(--color-primary-darkest);
    margin-left:10px;
    margin-right:10px;
}
.markdown-preview-view .internal-link:hover
{
  background-color: var(--color-primary-darkest);
  color: var(--color-primary-lightest);
}

.markdown-preview-view .internal-link:active
{
	background-color: var(--color-primary-dark);
    box-shadow:0px 0px 0px var(--color-primary),
    0px 0px 0px var(--color-primary-darkest);
}

.cm-s-obsidian span.cm-link, .cm-s-obsidian span.cm-hmd-internal-link {
    color: var(--text-accent);
    text-decoration: none;
    color:var(--color-text-dark);
}

.search-input{
    display: block;
    border-radius: 5px;
    margin: 0 auto 8px auto;
    width: calc(100% - 28px);
    box-shadow:-5px -3px 6px var(--color-primary),
    6px 2px 8px var(--color-primary-darkest);
}

.search-info-container {
    color: var(--color-primary);
    padding: 0 14px;
    font-size: 14px;
    line-height: 1.5;
    background-color: var(--color-primary);
}

input[type="text"], input[type="email"], input[type="password"], input[type="number"] {
    background: rgba(0, 0, 0, 0);
    border: 1px solid #30303000;
    color: #000000;
    font-family: 'Inter', sans-serif;
    padding: 5px 14px;
    font-size: 16px;
    border-radius: 4px;
    outline: none;
    height: 30px;
}


.nav-action-button {
	border-radius: 5px;
    color: var(--text-muted);
    cursor: pointer;
    box-shadow:-5px -3px 6px var(--color-primary),
    6px 2px 8px var(--color-primary-darkest);
}
.nav-action-button:hover{
  color: var(--color-primary-lightest);
  background-color: var(--color-primary-darkest);
}

.nav-action-button:active{
	background-color: var(--color-primary-dark);
    box-shadow:0px 0px 0px var(--color-primary),
    0px 0px 0px var(--color-primary-darkest);
}

.workspace-leaf-content[data-type='search'] .nav-action-button.is-active, .workspace-leaf-content[data-type='backlink'] .nav-action-button.is-active {
    background-color: var(--color-primary-darkest);
    color: var(--text-on-accent);
}

.side-dock-ribbon-action {
	border-radius: 5px;
    box-shadow:-5px -3px 6px var(--color-primary),
    6px 2px 8px var(--color-primary-darkest);
}

.side-dock-ribbon-action:hover{
  color: var(--color-primary-lightest);
  background-color: var(--color-primary-darkest);
}

.side-dock-ribbon-action:active{
	background-color: var(--color-primary-dark);
    box-shadow:0px 0px 0px var(--color-primary),
    0px 0px 0px var(--color-primary-darkest);
}


.view-action {
    margin: 0 8px;
    cursor: pointer;
    color: var(--text-muted);
    position: relative;
    padding-bottom: 5px;
    top: 3px;
    border-radius: 2px;
    box-shadow:-5px -3px 6px var(--color-primary),
    6px 2px 8px var(--color-primary-darkest);

}

.view-action:hover{
  color: var(--color-primary-lightest);
  background-color: var(--color-primary-darkest);
}

.view-action:active{
	background-color: var(--color-primary-dark);
    box-shadow:0px 0px 0px var(--color-primary),
    0px 0px 0px var(--color-primary-darkest);
}

.workspace-tab-header-inner {
    height: 100%;
    display: flex;
    border-radius: 5px;
    box-shadow:-5px -3px 6px var(--color-primary),
    6px 2px 8px var(--color-primary-darkest);
}
.workspace-tab-header-inner:hover{
  color: var(--color-primary-lightest);
  background-color: var(--color-primary-darkest);
}

.workspace-tab-header-inner:active
{
	background-color: var(--color-primary-dark);
    box-shadow:0px 0px 0px var(--color-primary),
    0px 0px 0px var(--color-primary-darkest);
}
.workspace-ribbon-collapse-btn {
    margin-top: 0px;
    padding: 10px 6px 4px 6px;
    cursor: pointer;
    color: var(--text-faint);
    transform: none;
    transition: transform 100ms ease-in-out;
    cursor: pointer;
    box-shadow:-5px -3px 6px var(--color-primary),
    6px 2px 8px var(--color-primary-darkest);
}
.workspace-ribbon-collapse-btn:hover{
  color: var(--color-primary-lightest);
  background-color: var(--color-primary-darkest);
}

.workspace-ribbon-collapse-btn:active{
	background-color: var(--color-primary-dark);
    box-shadow:0px 0px 0px var(--color-primary),
    0px 0px 0px var(--color-primary-darkest);
}
.side-dock-ribbon-action {
    padding-bottom: 5px;
    margin-top: 10px;
}

.workspace-tab-header-inner {
    padding-top: 4px;
    height: 100%;
    display: flex;
    margin-left:10px;
    margin-right:10px;
}
.workspace-tab-header-container {
  display: flex;
  background-color: var(--background-secondary-alt);
  height: 30px;
  padding-top: 4px;
  margin-bottom: 10px;
}
.nav-action-button {
  color: var(--text-muted);
  padding:0 10px 0 10px; 
  cursor: pointer;
  margin-left:5px;
  margin-right:5px;
}
.nav-buttons-container {
  display: flex;
  justify-content: center;
  margin-left:10px;
  margin-right:10px;
}
.workspace-leaf-content[data-type='search'] .nav-action-button, .workspace-leaf-content[data-type='backlink'] .nav-action-button {
    padding: 5px 8px 0 8px;
    margin: 0 3px 10px 3px;
    border-radius: 4px;
    margin-left:10px;
    margin-right:10px;
}

.view-actions {
	padding-top: 6px;
    padding-bottom: 5px;
    justify-content: flex-end;
    margin-bottom: 0px;
}
.horizontal-tab-content, .vertical-tab-content {
    background-color: var(--background-secondary);
    padding: 5px 30px;
}
/*到为止这里是所有按键的阴影设置*/
.markdown-preview-view .file-embed {
    background-color: var(--background-primary);
    border-radius: 4px;
    border: 2px solid var(--text-selection);
    padding: 5px 20px 5px 20px;
    margin: 10px 0px 10px 0px;
}

.file-embed-title {
    font-size: 12px;
    height: 40px;
    text-overflow: ellipsis;
    overflow: hidden;
    white-space: nowrap;
}


/* ===========================*/


/* ====== GUI tweaks =========*/


/* ===========================*/


/* ===== snappier animations ==== */

.workspace-tab-header,
.workspace-tab-header-inner,
.workspace-tab-container-before,
.workspace-tab-container-after {
    transition: background-color 100ms linear;
}


/* =====  ribbon vertical =========*/

.workspace-ribbon-collapse-btn {
    margin-top: 0px;
    padding: 10px 6px 4px 6px;
    cursor: pointer;
    color: var(--text-faint);
    transform: none;
    transition: transform 100ms ease-in-out;
    cursor: pointer;

}

.workspace-ribbon.is-collapsed {
    background-color: var(--background-secondary-alt);
}

.workspace-ribbon.mod-left.is-collapsed {
    border-right-color: var(--background-secondary-alt);
}

.workspace-ribbon.mod-right.is-collapsed {
    border-left-color: var(--background-secondary-alt);
}


/* ===== thinner & snappierhoriz resize handle =========*/

.workspace-split.mod-horizontal>*>.workspace-leaf-resize-handle {
    bottom: 0;
    left: 0;
    height: 3px;
    width: 100%;
    cursor: row-resize;
}

.workspace-leaf-resize-handle {
    transition: background-color 80ms linear;
}


/* ==== align top tab header with header title ==== */

.workspace-tab-header-container {
    display: flex;
    background-color: #5a5a5a;
    height: 36px;
    padding-top: 1px;
}


/* =====  left sidebar =========*/

.workspace-tab-header-container {/*重要tab*/
    display: flex;
    background-color: var(--background-secondary-alt);
    height: 36px;
    /* aligh tab header */
    padding-top: 1px;
}

.nav-header {
    padding: 10px 10px 4px 8px;
}

.nav-buttons-container {
    display: flex;
    justify-content: left;
    padding-bottom: 2px;
    border-bottom: 1px solid var(--background-modifier-border);
    margin-bottom: 2px;
}

.nav-action-button>svg {
    width: 14px;
    height: 14px;
}

.nav-action-button {
    color: var(--text-muted);
    cursor: pointer;
}

.nav-files-container {
    flex-grow: 1;
    overflow-y: auto;
    padding-left: 7px;
    /* reduce to 0 for more space */
    padding-bottom: 10px;
    padding-right: 20px;
    margin-bottom: 10px;
}


/* ----file xplor : smaller & bold vault title--- */

.nav-folder.mod-root>.nav-folder-title {
    padding-left: 6px;
    font-size: 14px;
    font-weight: bolder;
    top: -6px;
    /* higher */
    cursor: default;
}


/*----file explorer smaller fonts & line height----*/

.nav-file-title,
.nav-folder-title {
    background-color: var(--color-primary-dark);
    font-size: 12px;
    width: 180px;
    line-height: 14px;
    cursor: pointer;
    position: relative;
    white-space: nowrap;
    border-width: 1px;
    border-style: solid;
    border-color: transparent;
    border-image: initial;
    border-radius: 5px;
    padding: 1px 14px 0px 20px;
    margin: 10px;
    box-shadow:-5px -3px 6px var(--color-primary),
    6px 2px 8px var(--color-primary-darkest);
}

 

.nav-file.is-active > .nav-file-title, .nav-file.is-active > .nav-folder-title, .nav-file.is-active > .nav-folder-collapse-indicator, .nav-folder.is-active > .nav-file-title, .nav-folder.is-active > .nav-folder-title, .nav-folder.is-active > .nav-folder-collapse-indicator {
    color: #c3ffae;
    box-shadow:0px 0px 0px var(--color-primary),
    0px 0px 0px var(--color-primary-darkest);
}
 
/*---- nav arrows adjust location ----*/

.nav-folder-collapse-indicator {
    position: absolute;
    left: 12px;
    top: 4px;
    width: 9px;
    height: 9px;
    transition: transform 50ms linear 0s;
}

.nav-folder.is-collapsed .nav-folder-collapse-indicator {
    transform: translateX(-4px) translateY(1px) rotate(-90deg);
}


/* ===== smaller view-actions icons ===== */

.view-action>svg {
    width: 14px;
    height: 14px;
}

.view-header-icon>svg {
    width: 14px;
    height: 14px;
}

.workspace-tab-header-inner-icon>svg {
    width: 14px;
    height: 14px;
}


/* ===== brings back the selection highlight - thanks Klaas! ==== */

.suggestion-item.is-selected {
    background-color: var(--text-accent);
}


/* ====== scrollbars:no rounded corners =========*/

::-webkit-scrollbar-thumb {
    -webkit-border-radius: 5px;
    box-shadow: -5px -3px 4px var(--color-primary),
    6px 2px 6px var(--color-primary-darkest);
}

::-webkit-scrollbar-thumb:hover {
	background-color: var(--color-primary-darkest);
    -webkit-border-radius: 5px;
    box-shadow:  -5px -3px 4px var(--color-primary),
    6px 2px 6px var(--color-primary-darkest);

}

::-webkit-scrollbar-thumb:active {
	background-color: var(--color-primary-darkest);
    -webkit-border-radius: 5px;
    box-shadow:  -5px -3px 4px var(--color-primary),
    6px 2px 6px var(--color-primary-darkest);

}


/*==== tabs =====*/

.workspace-tab-header-inner {
    height: 100%;
    display: flex;
}

.workspace-tab-container-before,
.workspace-tab-container-after {
    width: 0px;
    height: 100%;
}


/* ====== font size headers =========*/

.view-header-title {
    font-size: 14px;
    font-weight: 600;
}


/* ===== view header color ==========*/

.workspace-leaf.mod-active .view-header-icon {
    padding: 5px 10px;
    color: var(--interactive-accent);
    cursor: grab;
    position: relative;
    top: 2px;
}

.workspace-leaf.mod-active .view-header {
    background-color: var(--background-primary);
    border-bottom: 2px solid var(--interactive-accent);
}

.view-header {/*重要栏*/
    height: 36px;
    display: flex;
    border-top: 2px var(--background-secondary-alt);
    border-bottom: 2px solid var(--background-secondary-alt);
    background-color: var(--background-secondary-alt);
    z-index: 1;
}


/* remove the gradient between title and icons */

.workspace-leaf.mod-active .view-header-title-container:after {
    background: var(--background-primary);
}

.view-header-title-container:after {/*重要*/
    content: '';
    position: absolute;
    top: 0;
    right: 0;
    width: 30px;
    height: 32px;
    background: var(--background-secondary-alt);
    /*border-right: 1px solid var(--background-modifier-border);*/
}


/* ===== tag pane ===================*/

.tag-pane-tag {
    font-size: 11px;
    line-height: 20px;
}

.tag-pane-tag-count {
    top: 2px;
    right: 10px;
    font-size: 11px;
    background-color: var(--background-secondary-alt);
    line-height: 12px;
    border-radius: 3px;
    padding: 2px 4px;
}

.pane-clickable-item {
    padding: 0px 15px;
}


/*==== separators =====*/

.workspace-leaf-resize-handle {/*拖拽分页*/
    padding: 0px 1px;
    background-color: var(--color-primary-darkest)
}

.workspace-leaf-resize-handle:hover {
    background-color: #484848;
}


/* a bit more padding on the left side */

.markdown-preview-view {
    padding: 20px 30px 30px 45px;
}


/*===== backlink pane smaller fonts=======*/

.side-dock-collapsible-section-header {
    font-size: 12px;
    padding: 3px 14px 0 34px;
    user-select: none;
    cursor: pointer;
    position: relative;
}

.search-result-container {
    padding: 0px 4px 4px 4px;
}

.search-result-file-title {
    font-size: 14px;
    color: var(--color-text-darkest);
    border-radius: 0px;
    border-top: 1px solid var(--background-modifier-border);
    padding: 6px 12px 0px 18px;
}

.search-result-file-match,
.search-result-file-matches {
    color: var(--text-muted);
    font-size: 12px;
    line-height: 25px;
    padding: 2px 5px;
    margin-bottom: 3px;
}

.search-result-file-match:not(:first-child) {
    margin-top: 0px;
}
/*============反link的格式==========*/
.search-result-file-matched-text {
    color: var(--color-text-darkest)/*var(--text-matched)*/;
    background-color: var(--background-secondary-alt);
    box-shadow:-5px -3px 5px var(--color-primary),
    6px 2px 9px var(--color-primary-darkest);
    margin-left:10px;
    margin-right:10px;
    padding-right: 2.5px;
    padding-left:2.5px;
    padding-top: 2.5px;
    padding-bottom:2.5px;
}
.search-result-file-matched-text:hover {
    color: var(--text-matched) ;
    background-color: var(--color-primary-darkest);
}

.search-result-file-matched-text:active {
    background-color: var(--background-secondary-alt);
    box-shadow:0px 0px 0px var(--color-primary),
    0px 0px 0px var(--color-primary-darkest);

}
/*=======================================================================*/

.search-info-more-matches {
    color: var(--text-faint);
    text-decoration: overline;
    font-size: 10px;
    line-height: 30px;
}


/* the small text ... and XX matches */


/*========= remove rounded corners =======*/

.workspace-tab-header.is-active {
    border-radius: 5px;
}

.nav-folder-title {
    border-radius: 5px;
}




.workspace-split.mod-left-split .workspace-tabs .workspace-leaf {
    border-top-left-radius: 0px;
}

.workspace-split.mod-right-split .workspace-tabs .workspace-leaf {
    border-top-right-radius: 0px;
}


/*======= flat status bar ====*/

.status-bar {
    background-color: var(--color-primary-darkest);
    border-top: 0px solid var(--background-modifier-border);
    color: var(--color-text-darkest);
}


/* ======= graph view ==============*/

.graph-view.color-fill {
    color: black;
    /*var(--text-muted)if you want neutral color*/
}

.graph-view.color-circle {
    color: var(--text-normal);
}

.graph-view.color-line {
    color: var(--background-modifier-border);
}

.graph-view.color-text {
    color: var(--text-normal);
}

.graph-view.color-fill-highlight {
    color: var(--interactive-accent);
}

.graph-view.color-line-highlight {
    color: #000000;
}


/*==== codemirror line numbers gutter edit mode ====*/

.cm-s-obsidian .CodeMirror-linenumber {
    color: var(--text-accent);
    opacity: 0.3;
    font-size: 14px;
    font-family: Consolas, monospace;
}

.CodeMirror-gutter-elt {
    position: absolute;
    cursor: default;
    z-index: 4;
}

.CodeMirror-linenumber {
    padding: 0 3px 0 0px;
    min-width: 20px;
    text-align: right;
    white-space: nowrap;
}


/*============bigger link popup preview  ================*/

.popover.hover-popover {
    position: absolute;
    z-index: var(--layer-popover);
    transform: scale(0.8);
    max-height: 800px;
    /* was 300 */
    min-height: 100px;
    width: 500px;
    overflow: hidden;
    padding: 0;
    border-bottom: none;
}

.popover {
    background-color: var(--background-primary);
    border: 1px solid var(--background-primary-alt);
    box-shadow: 3px 3px 7px var(--background-modifier-box-shadow);
    border-radius: 6px;
    padding: 15px 20px 10px 20px;
    position: relative;
}


/* =========== footnotes ========= */

.markdown-preview-view .mod-highlighted {
    transition: background-color 1s ease;
    background-color: var(--text-highlight-bg);
    color: var(--text-matched);
}

.footnotes-list {
    font-size: 12px
}


/*=============== add mods below ================*/


/* Wrap long nav text and some paddings */



/* Indent wrapped nav text */

.nav-file-title-content {
    margin-left: 10px;
    text-indent: -10px;
}


/*=============== add mods below ================*/


/*=============== add mods below ================*/


/*=============== add mods below ================*/


/*===============================================*/


/*                                    .__    .___*/


/*  _____   ___________  _____ _____  |__| __| _/*/


/* /     \_/ __ \_  __ \/     \\__  \ |  |/ __ | */


/*|  Y Y  \  ___/|  | \/  Y Y  \/ __ \|  / /_/ | */


/*|__|_|  /\___  >__|  |__|_|  (____  /__\____ | */


/*      \/     \/            \/     \/        \/ */


/*======== optionnal mermaid style below ========*/

.label {
    font-family: Segoe UI, "trebuchet ms", verdana, arial, Fira Code, consolas, monospace !important;
    color: var(--text-normal) !important;
}

.label text {
    fill: var(--background-primary-alt) !important;
}

.node rect,
.node circle,
.node ellipse,
.node polygon,
.node path {
    fill: var(--background-modifier-border) !important;
    stroke: var(--text-normal) !important;
    stroke-width: 0.5px !important;
}

.node .label {
    text-align: center !important;
}

.node.clickable {
    cursor: pointer !important;
}

.arrowheadPath {
    fill: var(--text-faint) !important;
}

.edgePath .path {
    stroke: var(--text-faint) !important;
    stroke-width: 1.5px !important;
}

.flowchart-link {
    stroke: var(--text-faint) !important;
    fill: none !important;
}

.edgeLabel {
    background-color: var(--background-primary) !important;
    text-align: center !important;
}

.edgeLabel rect {
    opacity: 0 !important;
}

.cluster rect {
    fill: var(--background-primary-alt) !important;
    stroke: var(--text-faint) !important;
    stroke-width: 1px !important;
}

.cluster text {
    fill: var(--background-primary) !important;
}

div.mermaidTooltip {
    position: absolute !important;
    text-align: center !important;
    max-width: 200px !important;
    padding: 2px !important;
    font-family: Segoe UI, "trebuchet ms", verdana, arial !important;
    font-size: 10px !important;
    background: var(--background-secondary) !important;
    border: 1px solid var(--text-faint) !important;
    border-radius: 2px !important;
    pointer-events: none !important;
    z-index: 100 !important;
}


/* Sequence Diagram variables */

.actor {
    stroke: var(--text-accent) !important;
    fill: var(--background-secondary-alt) !important;
}

text.actor>tspan {
    fill: var(--text-muted) !important;
    stroke: none !important;
}

.actor-line {
    stroke: var(--text-muted) !important;
}

.messageLine0 {
    stroke-width: 1.5 !important;
    stroke-dasharray: none !important;
    stroke: var(--text-muted) !important;
}

.messageLine1 {
    stroke-width: 1.5 !important;
    stroke-dasharray: 2, 2 !important;
    stroke: var(--text-muted) !important;
}

#arrowhead path {
    fill: var(--text-muted) !important;
    stroke: var(--text-muted) !important;
}

.sequenceNumber {
    fill: var(--background-primary) !important;
}

#sequencenumber {
    fill: var(--text-muted) !important;
}

#crosshead path {
    fill: var(--text-muted) !important;
    stroke: var(--text-muted) !important;
}

.messageText {
    fill: var(--text-muted) !important;
    stroke: var(--text-muted) !important;
}

.labelBox {
    stroke: var(--text-accent) !important;
    fill: var(--background-secondary-alt) !important;
}

.labelText,
.labelText>tspan {
    fill: var(--text-muted) !important;
    stroke: none !important;
}

.loopText,
.loopText>tspan {
    fill: var(--text-muted) !important;
    stroke: none !important;
}

.loopLine {
    stroke-width: 2px !important;
    stroke-dasharray: 2, 2 !important;
    stroke: var(--text-accent) !important;
    fill: var(--text-accent) !important;
}

.note {
    stroke: var(--text-normal) !important;
    fill: var(--text-accent) !important;
}

.noteText,
.noteText>tspan {
    fill: var(--background-secondary-alt) !important;
    stroke: none !important;
}


/* Gantt chart variables */

.activation0 {
    fill: var(--background-secondary) !important;
    stroke: var(--text-accent) !important;
}

.activation1 {
    fill: var(--background-secondary) !important;
    stroke: var(--text-accent) !important;
}

.activation2 {
    fill: var(--background-secondary) !important;
    stroke: var(--text-accent) !important;
}


/** Section styling */

.mermaid-main-font {
    font-family: Segoe UI, "trebuchet ms", verdana, arial !important;
}

.section {
    stroke: none !important;
    opacity: 0.2 !important;
}

.section0 {
    fill: var(--text-faint) !important;
}

.section2 {
    fill: var(--text-accent) !important;
}

.section1,
.section3 {
    fill: var(--text-normal) !important;
    opacity: 0.2 !important;
}

.sectionTitle0 {
    fill: var(--text-normal) !important;
}

.sectionTitle1 {
    fill: var(--text-normal) !important;
}

.sectionTitle2 {
    fill: var(--text-normal) !important;
}

.sectionTitle3 {
    fill: var(--text-normal) !important;
}

.sectionTitle {
    text-anchor: start !important;
    font-size: 9px !important;
    text-height: 14px !important;
    font-family: Segoe UI, "trebuchet ms", verdana, arial !important;
}


/* Grid and axis */

.grid .tick {
    stroke: var(--text-muted) !important;
    opacity: 0.2 !important;
    shape-rendering: crispEdges !important;
}

.grid .tick text {
    font-family: Segoe UI, "trebuchet ms", verdana, arial !important;
}

.grid path {
    stroke-width: 0 !important;
}


/* Today line */

.today {
    fill: none !important;
    stroke: var(--background-modifier-error) !important;
    stroke-width: 2px !important;
}


/* Task styling */


/* Default task */

.task {
    stroke-width: 0.5px !important;
}

.taskText {
    text-anchor: middle !important;
    font-family: Segoe UI, "trebuchet ms", verdana, arial !important;
}

.taskText:not([font-size]) {
    font-size: 9px !important;
}

.taskTextOutsideRight {
    fill: var(--text-normal) !important;
    text-anchor: start !important;
    font-size: 9px !important;
    font-family: Segoe UI, "trebuchet ms", verdana, arial !important;
}

.taskTextOutsideLeft {
    fill: var(--text-normal) !important;
    text-anchor: end !important;
    font-size: 9px !important;
}


/* Special case clickable */

.task.clickable {
    cursor: pointer !important;
}

.taskText.clickable {
    cursor: pointer !important;
    fill: var(--interactive-accent_hover) !important !important;
    font-weight: bold !important;
} 

.taskTextOutsideLeft.clickable {
    cursor: pointer !important;
    fill: var(--interactive-accent_hover) !important !important;
    font-weight: bold !important;
}

.taskTextOutsideRight.clickable {
    cursor: pointer !important;
    fill: var(--interactive-accent_hover) !important !important;
    font-weight: bold !important;
}


/* Specific task settings for the sections*/

.taskText0,
.taskText1,
.taskText2,
.taskText3 {
    fill: var(--text-normal) !important;
}

.task0,
.task1,
.task2,
.task3 {
    fill: var(--background-secondary-alt) !important;
    stroke: var(--text-muted) !important;
}

.taskTextOutside0,
.taskTextOutside2 {
    fill: var(--text-muted) !important;
}

.taskTextOutside1,
.taskTextOutside3 {
    fill: var(--text-muted) !important;
}


/* Active task */

.active0,
.active1,
.active2,
.active3 {
    fill: var(--text-accent) !important;
    stroke: var(--text-muted) !important;
}

.activeText0,
.activeText1,
.activeText2,
.activeText3 {
    fill: var(--text-normal) !important !important;
}


/* Completed task */

.done0,
.done1,
.done2,
.done3 {
    stroke: var(--text-muted) !important;
    fill: var(--text-faint) !important;
    stroke-width: 1 !important;
}

.doneText0,
.doneText1,
.doneText2,
.doneText3 {
    fill: var(--text-normal) !important !important;
}


/* Tasks on the critical line */

.crit0,
.crit1,
.crit2,
.crit3 {
    stroke: var(--accent-strong) !important;
    fill: var(--accent-strong) !important;
    stroke-width: 1!important;
}

.activeCrit0,
.activeCrit1,
.activeCrit2,
.activeCrit3 {
    stroke: var(--accent-strong) !important;
    fill: var(--text-accent) !important;
    stroke-width: 1 !important;
}

.doneCrit0,
.doneCrit1,
.doneCrit2,
.doneCrit3 {
    stroke: var(--accent-strong) !important;
    fill: var(--text-muted) !important;
    stroke-width: 0.5 !important;
    cursor: pointer !important;
    shape-rendering: crispEdges !important;
}

.milestone {
    transform: rotate(45deg) scale(0.8, 0.8) !important;
}

.milestoneText {
    font-style: italic !important;
}

.doneCritText0,
.doneCritText1,
.doneCritText2,
.doneCritText3 {
    fill: var(--text-normal) !important !important;
}

.activeCritText0,
.activeCritText1,
.activeCritText2,
.activeCritText3 {
    fill: var(--text-normal) !important !important;
}

.titleText {
    text-anchor: middle !important;
    font-size: 16px !important;
    fill: var(--text-normal) !important;
    font-family: Segoe UI, "trebuchet ms", verdana, arial !important;
}

g.classGroup text {
    fill: var(--text-accent) !important;
    stroke: none !important;
    font-family: consolas, monospace, Segoe UI, "trebuchet ms", verdana, arial !important;
    font-size: 8px !important;
}

g.classGroup text .title {
    font-weight: bolder !important;
}

g.clickable {
    cursor: pointer !important;
}

g.classGroup rect {
    fill: var(--background-secondary-alt) !important;
    stroke: var(--text-accent) !important;
}

g.classGroup line {
    stroke: var(--text-accent) !important;
    stroke-width: 1 !important;
}

.classLabel .box {
    stroke: none !important;
    stroke-width: 0 !important;
    fill: var(--background-secondary-alt) !important;
    opacity: 0.2 !important;
}

.classLabel .label {
    fill: var(--text-accent) !important;
    font-size: 10px !important;
}

.relation {
    stroke: var(--text-accent) !important;
    stroke-width: 1 !important;
    fill: none !important;
}

.dashed-line {
    stroke-dasharray: 3 !important;
}

#compositionStart {
    fill: var(--text-accent) !important;
    stroke: var(--text-accent) !important;
    stroke-width: 1 !important;
}

#compositionEnd {
    fill: var(--text-accent) !important;
    stroke: var(--text-accent) !important;
    stroke-width: 1 !important;
}

#aggregationStart {
    fill: var(--background-secondary-alt) !important;
    stroke: var(--text-accent) !important;
    stroke-width: 1 !important;
}

#aggregationEnd {
    fill: var(--background-secondary-alt) !important;
    stroke: var(--text-accent) !important;
    stroke-width: 1 !important;
}

#dependencyStart {
    fill: var(--text-accent) !important;
    stroke: var(--text-accent) !important;
    stroke-width: 1 !important;
}

#dependencyEnd {
    fill: var(--text-accent) !important;
    stroke: var(--text-accent) !important;
    stroke-width: 1 !important;
}

#extensionStart {
    fill: var(--text-accent) !important;
    stroke: var(--text-accent) !important;
    stroke-width: 1 !important;
}

#extensionEnd {
    fill: var(--text-accent) !important;
    stroke: var(--text-accent) !important;
    stroke-width: 1 !important;
}

.commit-id,
.commit-msg,
.branch-label {
    fill: var(--text-muted) !important;
    color: var(--text-muted) !important;
    font-family: Segoe UI, "trebuchet ms", verdana, arial !important;
}

.pieTitleText {
    text-anchor: middle !important;
    font-size: 18px !important;
    fill: var(--text-normal) !important;
    font-family: Segoe UI, "trebuchet ms", verdana, arial !important;
}

.slice {
    font-family: Segoe UI, "trebuchet ms", verdana, arial !important;
}

g.stateGroup text {
    fill: var(--text-accent) !important;
    stroke: none !important;
    font-size: 10px !important;
    font-family: Segoe UI, "trebuchet ms", verdana, arial !important;
}

g.stateGroup text {
    fill: var(--text-accent) !important;
    stroke: none !important;
    font-size: 10px !important;
}

g.stateGroup .state-title {
    font-weight: bolder !important;
    fill: var(--background-secondary-alt) !important;
}

g.stateGroup rect {
    fill: var(--background-secondary-alt) !important;
    stroke: var(--text-accent) !important;
}

g.stateGroup line {
    stroke: var(--text-accent) !important;
    stroke-width: 1 !important;
}

.transition {
    stroke: var(--text-accent) !important;
    stroke-width: 1 !important;
    fill: none !important;
}

.stateGroup .composit {
    fill: var(--text-normal) !important;
    border-bottom: 1px !important;
}

.stateGroup .alt-composit {
    fill: #e0e0e0 !important;
    border-bottom: 1px !important;
}

.state-note {
    stroke: var(--text-faint) !important;
    fill: var(--text-accent) !important;
}

.state-note text {
    fill: black !important;
    stroke: none !important;
    font-size: 10px !important;
}

.stateLabel .box {
    stroke: none !important;
    stroke-width: 0 !important;
    fill: var(--background-secondary-alt) !important;
    opacity: 0.5 !important;
}

.stateLabel text {
    fill: black !important;
    font-size: 10px !important;
    font-weight: bold !important;
    font-family: Segoe UI, "trebuchet ms", verdana, arial !important;
}

.node circle.state-start {
    fill: black !important;
    stroke: black !important;
}

.node circle.state-end {
    fill: black !important;
    stroke: var(--text-normal) !important;
    stroke-width: 1.5 !important;
}

#statediagram-barbEnd {
    fill: var(--text-accent) !important;
}

.statediagram-cluster rect {
    fill: var(--background-secondary-alt) !important;
    stroke: var(--text-accent) !important;
    stroke-width: 1px !important;
}

.statediagram-cluster rect.outer {
    rx: 5px !important;
    ry: 5px !important;
}

.statediagram-state .divider {
    stroke: var(--text-accent) !important;
}

.statediagram-state .title-state {
    rx: 5px !important;
    ry: 5px !important;
}

.statediagram-cluster.statediagram-cluster .inner {
    fill: var(--text-normal) !important;
}

.statediagram-cluster.statediagram-cluster-alt .inner {
    fill: #e0e0e0 !important;
}

.statediagram-cluster .inner {
    rx: 0 !important;
    ry: 0 !important;
}

.statediagram-state rect.basic {
    rx: 5px !important;
    ry: 5px !important;
}

.statediagram-state rect.divider {
    stroke-dasharray: 10, 10 !important;
    fill: #efefef !important;
}

.note-edge {
    stroke-dasharray: 5 !important;
}

.statediagram-note rect {
    fill: var(--text-accent) !important;
    stroke: var(--text-muted) !important;
    stroke-width: 1px !important;
    rx: 0 !important;
    ry: 0 !important;
}

:root {
    --mermaid-font-family: '"trebuchet ms", verdana, arial' !important;
    --mermaid-font-family: "Comic Sans MS", "Comic Sans", cursive !important;
}


/* Classes common for multiple diagrams */

.error-icon {
    fill: var(--text-error) !important;
}

.error-text {
    fill: var(--text-muted) !important;
    stroke: var(--text-muted) !important;
}

.edge-thickness-normal {
    stroke-width: 1px !important;
}

.edge-thickness-thick {
    stroke-width: 3px !important;
}

.edge-pattern-solid {
    stroke-dasharray: 0 !important;
}

.edge-pattern-dashed {
    stroke-dasharray: 3 !important;
}

.edge-pattern-dotted {
    stroke-dasharray: 2 !important;
}

.marker {
    fill: var(--text-muted) !important;
}

.marker.cross {
    stroke: var(--text-muted) !important;
}

rect {
    fill: var(--text-accent-hover);
    fill-opacity: 1;
    stroke: var(--text-normal);
}
/*********************************/
/* Headings - EDITOR and PREVIEW */
/*********************************/


/* headings for editor and preview */
.cm-header-1, .markdown-preview-view h1
{
  font-family: var(--font-family-editor);
  font-weight: 500;
  font-size: var(--font-size-h1);
  color: var(--text-title-h1);
  text-shadow:-4px -2px 4px var(--color-primary-light),
      3px 2px 5px var(--color-primary-darkest);
}

.cm-header-2, .markdown-preview-view h2
{
  font-family: var(--font-family-editor);
  font-weight: 400;
  font-size: var(--font-size-h2);
  color: var(--text-title-h2);
  text-shadow:-4px -2px 4px var(--color-primary-light),
      3px 2px 5px var(--color-primary-darkest);
}

.cm-header-3, .markdown-preview-view h3
{
  font-family: var(--font-family-editor);
  font-weight: 500;
  font-size: var(--font-size-h3);
  color: var(--text-title-h3);
  text-shadow:-4px -2px 4px var(--color-primary-light),
      3px 2px 5px var(--color-primary-darkest);
}

.cm-header-4, .markdown-preview-view h4
{
  font-family: var(--font-family-editor);
  font-weight: 500;
  font-size: var(--font-size-h4);
  color: var(--text-title-h4);
 text-shadow:-4px -2px 4px var(--color-primary-light),
      3px 2px 5px var(--color-primary-darkest);
}

.cm-header-5, .markdown-preview-view h5
{
  font-family: var(--font-family-editor);
  font-weight: 500;
  font-size: var(--font-size-h5);
  color: var(--text-title-h5);
 text-shadow:-4px -2px 4px var(--color-primary-light),
      3px 2px 5px var(--color-primary-darkest);
}

.cm-header-6, .markdown-preview-view h6
{
  font-family: var(--font-family-editor);
  font-weight: 500;
  font-size: var(--font-size-h6);
  color: var(--text-title-h6);
  text-shadow:-4px -2px 4px var(--color-primary-light),
      3px 2px 5px var(--color-primary-darkest);
}
/*********************myself****test*************************************/