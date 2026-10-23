<%@page import="affichage.PageRecherche"%>
<%@ page import="historique.HistoInsert" %>

<%
    try {

        HistoInsert t = new HistoInsert();
        t.setNomTable("v_histoinsert");

        String listeCrt[] = {};
        String listeInt[] = {};

        String libEntete[] = {
                "refobjet",
                "remarque",
                "datehistorique",
                "heure",
                "action",
                "objet"
        };

        PageRecherche pr = new PageRecherche(
                t,
                request,
                listeCrt,
                listeInt,
                4,
                libEntete,
                libEntete.length
        );

        pr.setTitre("Recherche Global");

        if (
                request.getParameter("remarque") != null &&
                        request.getParameter("remarque").compareToIgnoreCase("") != 0
        ) {
            pr.setAWhere(
                    " and upper(remarque) like upper('%" +
                            request.getParameter("remarque") +
                            "%')"
            );
        }

        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("historique/historique-liste.jsp");

        String[] colSomme = null;

        pr.creerObjetPage(libEntete, colSomme);

        String libEnteteAffiche[] = {
                "R&eacute;f&eacute;rence Objet",
                "Libelle",
                "Date",
                "Heure",
                "Action",
                "Objet"
        };

        pr.getTableau().setLibelleAffiche(libEnteteAffiche);

        HistoInsert[] ob = (HistoInsert[]) pr.getTableau().getData();
%>

<style>
    [data-apj-filter-root] .apj-table-column-filter.is-active .apj-table-column-filter-toggle .icon {
        color: white !important;
    }

    [data-apj-filter-root] .apj-table-column-filter.is-active .apj-table-column-filter-toggle::after {
        background: var(--White) !important;
    }

</style>
<div class="content-wrapper">

    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>


    <section class="content">

        <div class="row m-0">

            <div
                    class="col-md-12 nopadding"
                    data-apj-filter-root=""
            >

                <div class="box table-box">

                    <div class="box-body table-responsive no-padding">

                        <div
                                id="selectnonee"
                                class="scroll-table-container"
                        >

                            <table
                                    style="margin-bottom:0;"
                                    width="100%"
                                    border="0"
                                    align="center"
                                    cellpadding="3"
                                    cellspacing="3"
                                    class="table table-hover table-striped"
                                    id="table-apj"
                                    data-apj-filter-table=""
                            >

                                <!-- ============================= -->
                                <!-- HEADER                        -->
                                <!-- ============================= -->

                                <thead>

                                <tr class="head">


                                    <!-- REFERENCE OBJET -->

                                    <th
                                            data-apj-filter-column=""
                                            data-apj-filter-label="R&eacute;f&eacute;rence Objet"
                                            width="19%"
                                            align="center"
                                            valign="top"
                                            class="contenuetable"
                                    >

                                        <a href="module.jsp?but=historique/historique-liste.jsp&amp;numPag=1&amp;colonne=&amp;ordre=&amp;colAffiche1=refobjet&amp;colAffiche2=remarque&amp;colAffiche3=datehistorique&amp;colAffiche4=heure&amp;colAffiche5=action&amp;colAffiche6=objet&amp;triCol=yes&amp;newcol=refobjet">

                                                <span multi-lang="">
                                                    R&eacute;f&eacute;rence Objet
                                                </span>

                                            <i
                                                    class="material-symbols-rounded"
                                                    style="
                                                        font-size:16px;
                                                        color:var(--Text-primary);
                                                        font-weight:400;
                                                    "
                                            >
                                                swap_vert
                                            </i>

                                        </a>

                                    </th>


                                    <!-- LIBELLE -->

                                    <th
                                            data-apj-filter-column=""
                                            data-apj-filter-label="Libelle"
                                            width="20%"
                                            align="center"
                                            valign="top"
                                            class="contenuetable"
                                    >

                                        <a href="module.jsp?but=historique/historique-liste.jsp&amp;numPag=1&amp;colonne=&amp;ordre=&amp;colAffiche1=refobjet&amp;colAffiche2=remarque&amp;colAffiche3=datehistorique&amp;colAffiche4=heure&amp;colAffiche5=action&amp;colAffiche6=objet&amp;triCol=yes&amp;newcol=remarque">

                                                <span multi-lang="">
                                                    Libelle
                                                </span>

                                            <i
                                                    class="material-symbols-rounded"
                                                    style="
                                                        font-size:16px;
                                                        color:var(--Text-primary);
                                                        font-weight:400;
                                                    "
                                            >
                                                swap_vert
                                            </i>

                                        </a>

                                    </th>


                                    <!-- DATE -->

                                    <th
                                            data-apj-filter-column=""
                                            data-apj-filter-label="Date"
                                            width="19%"
                                            align="center"
                                            valign="top"
                                            class="contenuetable"
                                    >

                                        <a href="module.jsp?but=historique/historique-liste.jsp&amp;numPag=1&amp;colonne=&amp;ordre=&amp;colAffiche1=refobjet&amp;colAffiche2=remarque&amp;colAffiche3=datehistorique&amp;colAffiche4=heure&amp;colAffiche5=action&amp;colAffiche6=objet&amp;triCol=yes&amp;newcol=datehistorique">

                                                <span multi-lang="">
                                                    Date
                                                </span>

                                            <i
                                                    class="material-symbols-rounded"
                                                    style="
                                                        font-size:16px;
                                                        color:var(--Text-primary);
                                                        font-weight:400;
                                                    "
                                            >
                                                swap_vert
                                            </i>

                                        </a>

                                    </th>


                                    <!-- HEURE -->

                                    <th
                                            data-apj-filter-column=""
                                            data-apj-filter-label="Heure"
                                            width="19%"
                                            align="center"
                                            valign="top"
                                            class="contenuetable"
                                    >

                                        <a href="module.jsp?but=historique/historique-liste.jsp&amp;numPag=1&amp;colonne=&amp;ordre=&amp;colAffiche1=refobjet&amp;colAffiche2=remarque&amp;colAffiche3=datehistorique&amp;colAffiche4=heure&amp;colAffiche5=action&amp;colAffiche6=objet&amp;triCol=yes&amp;newcol=heure">

                                                <span multi-lang="">
                                                    Heure
                                                </span>

                                            <i
                                                    class="material-symbols-rounded"
                                                    style="
                                                        font-size:16px;
                                                        color:var(--Text-primary);
                                                        font-weight:400;
                                                    "
                                            >
                                                swap_vert
                                            </i>

                                        </a>

                                    </th>


                                    <!-- ACTION -->

                                    <th
                                            data-apj-filter-column=""
                                            data-apj-filter-label="Action"
                                            width="20%"
                                            align="center"
                                            valign="top"
                                            class="contenuetable"
                                    >

                                        <a href="module.jsp?but=historique/historique-liste.jsp&amp;numPag=1&amp;colonne=&amp;ordre=&amp;colAffiche1=refobjet&amp;colAffiche2=remarque&amp;colAffiche3=datehistorique&amp;colAffiche4=heure&amp;colAffiche5=action&amp;colAffiche6=objet&amp;triCol=yes&amp;newcol=action">

                                                <span multi-lang="">
                                                    Action
                                                </span>

                                            <i
                                                    class="material-symbols-rounded"
                                                    style="
                                                        font-size:16px;
                                                        color:var(--Text-primary);
                                                        font-weight:400;
                                                    "
                                            >
                                                swap_vert
                                            </i>

                                        </a>

                                    </th>


                                    <!-- MENU -->

                                    <th class="contenuetable"></th>


                                </tr>

                                </thead>


                                <!-- ============================= -->
                                <!-- BODY                          -->
                                <!-- ============================= -->

                                <tbody>

                                <%
                                    for (int i = 0; i < ob.length; i++) {
                                %>

                                <tr
                                        style="height:45px;"
                                        onmouseover="this.style.backgroundColor='#EAEAEA'"
                                        onmouseout="this.style.backgroundColor=''"
                                >


                                    <!-- REFERENCE -->

                                    <td
                                            class="contenuetable"
                                            width="19%"
                                            align="left"
                                    >

                                        <% if (ob[i].getFiche() != null && !ob[i].getFiche().trim().isEmpty()) { %>
                                        <a href="module.jsp?but=<%=ob[i].getFiche()%>&amp;id=<%=ob[i].getRefObjet()%>">
                                            <%=ob[i].getRefObjet()%>
                                        </a>
                                        <% } else { %>
                                            <%=ob[i].getRefObjet()%>
                                        <% } %>

                                    </td>


                                    <!-- LIBELLE -->

                                    <td
                                            class="contenuetable"
                                            width="20%"
                                            align="left"
                                    >

                                        <%=ob[i].getRemarque()%>

                                    </td>


                                    <!-- DATE -->

                                    <td
                                            class="contenuetable"
                                            width="19%"
                                            align="left"
                                    >

                                        <%=ob[i].getDateHistorique()%>

                                    </td>


                                    <!-- HEURE -->

                                    <td
                                            class="contenuetable"
                                            width="19%"
                                            align="left"
                                    >

                                        <%=ob[i].getHeure()%>

                                    </td>


                                    <!-- ACTION -->

                                    <td
                                            class="contenuetable"
                                            width="20%"
                                            align="left"
                                    >

                                        <%=ob[i].getAction()%>

                                    </td>


                                    <!-- ACTIONS -->

                                    <td
                                            style="
                                                padding:4px 15px;
                                                position:relative;
                                            "
                                    >

                                        <button
                                                type="button"
                                                class="more_info"
                                                id="ellipsis-<%=i%>"
                                                style="
                                                    border:none;
                                                    background:none;
                                                "
                                        >

                                            <i class="material-symbols-rounded">
                                                more_vert
                                            </i>

                                        </button>


                                        <div
                                                id="more-action-<%=i%>"
                                                class="mode_action"
                                                style="
                                                    display:none;
                                                    margin-left:unset;
                                                "
                                        >
                                        </div>

                                    </td>


                                </tr>

                                <%
                                    }
                                %>

                                </tbody>


                            </table>

                        </div>

                    </div>

                </div>

            </div>

        </div>


        <!-- ========================================= -->
        <!-- FILTRE DE TABLEAU                         -->
        <!-- ========================================= -->

        <script>

            (function (window, document) {

                "use strict";


                /*
                 * Evite de charger plusieurs fois le module
                 * si plusieurs tableaux sont présents.
                 */

                if (window.ApjDataTableFilter) {

                    window.ApjDataTableFilter.initAll(document);

                    return;

                }


                /* ========================================= */
                /* CSS                                       */
                /* ========================================= */

                const STYLE_ID = "apj-data-table-filter-styles";


                if (!document.getElementById(STYLE_ID)) {

                    const style = document.createElement("style");

                    style.id = STYLE_ID;


                    style.textContent =

                        "[data-apj-filter-root] { isolation: isolate; }\n" +

                        "[data-apj-filter-root] .apj-table-column-filter,\n" +
                        "[data-apj-filter-root] .apj-table-column-filter * {\n" +
                        "  box-sizing: border-box;\n" +
                        "}\n" +


                        "[data-apj-filter-root] .apj-table-column-filter {\n" +
                        "  display: block;\n" +
                        "  width: 100%;\n" +
                        "  min-width: 0;\n" +
                        "}\n" +


                        "[data-apj-filter-root] .apj-table-column-filter-summary {\n" +
                        "  display: flex;\n" +
                        "  min-width: 0;\n" +
                        "  min-height: 30px;\n" +
                        "  align-items: center;\n" +
                        "  gap: 6px;\n" +
                        "}\n" +


                        "[data-apj-filter-root] .apj-table-column-filter-label {\n" +
                        "  display: block;\n" +
                        "  min-width: 0;\n" +
                        "  flex: 1;\n" +
                        "  overflow: hidden;\n" +
                        "  text-overflow: ellipsis;\n" +
                        "  white-space: nowrap;\n" +
                        "}\n" +


                        "[data-apj-filter-root] .apj-table-column-filter-label > a {\n" +
                        "  display: flex;\n" +
                        "  align-items: center;\n" +
                        "  min-width: 0;\n" +
                        "  overflow: hidden;\n" +
                        "  text-overflow: ellipsis;\n" +
                        "  color: var(--Text-primary);\n" +
                        "}\n" +


                        "[data-apj-filter-root] .apj-table-column-filter-toggle {\n" +
                        "  position: relative;\n" +
                        "  display: inline-grid;\n" +
                        "  width: 28px;\n" +
                        "  height: 28px;\n" +
                        "  flex: 0 0 auto;\n" +
                        "  place-items: center;\n" +
                        "  padding: 0;\n" +
                        "  border: 0;\n" +
                        "  border-radius: 7px;\n" +
                        "  background: transparent;\n" +
                        "  color: var(--Text-secondary, #94a3b8);\n" +
                        "  cursor: pointer;\n" +
                        "}\n" +


                        "[data-apj-filter-root] .apj-table-column-filter-toggle:hover,\n" +
                        "[data-apj-filter-root] .apj-table-column-filter-toggle:focus-visible {\n" +
                        "  background: var(--Background-tertiaire, #eef2f7);\n" +
                        "  color: var(--Text-primary, #1e293b);\n" +
                        "  outline: 0;\n" +
                        "}\n" +


                        "[data-apj-filter-root] .apj-table-column-filter.is-active .apj-table-column-filter-toggle {\n" +
                        "  background: var(--Primaire-blue-main-color, #ffffff);\n" +
                        "  color: var(--Text-primary, #1e293b);\n" +
                        "  box-shadow: inset 0 0 0 1px rgba(79,70,229,.2);\n" +
                        "}\n" +


                        "[data-apj-filter-root] .apj-table-column-filter.is-active .apj-table-column-filter-toggle::after {\n" +
                        "  position: absolute;\n" +
                        "  top: 4px;\n" +
                        "  right: 4px;\n" +
                        "  width: 5px;\n" +
                        "  height: 5px;\n" +
                        "  border: 1px solid #fff;\n" +
                        "  border-radius: 50%;\n" +
                        "  background: var(--Primaire-blue-main-color, #4f46e5);\n" +
                        "  content: '';\n" +
                        "}\n" +


                        "[data-apj-filter-root] .apj-table-column-filter-toggle .icon {\n" +
                        "  width: 15px;\n" +
                        "  height: 15px;\n" +
                        "  flex: 0 0 auto;\n" +
                        "  fill: none;\n" +
                        "  stroke: currentColor;\n" +
                        "  stroke-linecap: round;\n" +
                        "  stroke-linejoin: round;\n" +
                        "  stroke-width: 1.8;\n" +
                        "}\n" +


                        "[data-apj-filter-root] .apj-table-column-filter-editor {\n" +
                        "  position: relative;\n" +
                        "  display: none;\n" +
                        "  width: 100%;\n" +
                        "  align-items: center;\n" +
                        "}\n" +


                        "[data-apj-filter-root] .apj-table-column-filter.is-editing .apj-table-column-filter-summary {\n" +
                        "  display: none;\n" +
                        "}\n" +


                        "[data-apj-filter-root] .apj-table-column-filter.is-editing .apj-table-column-filter-editor {\n" +
                        "  display: flex;\n" +
                        "}\n" +


                        "[data-apj-filter-root] .apj-table-column-filter-input {\n" +
                        "  width: 100%;\n" +
                        "  min-width: 76px;\n" +
                        "  height: 30px;\n" +
                        "  padding: 0 30px 0 9px;\n" +
                        "  border: 1px solid var(--Border, #cbd5e1);\n" +
                        "  border-radius: 7px;\n" +
                        "  background: var(--Background-primaire, #fff);\n" +
                        "  color: var(--Text-primary, #1e293b);\n" +
                        "  font: inherit;\n" +
                        "  font-size: 12.5px;\n" +
                        "  font-weight: 500;\n" +
                        "  outline: 0;\n" +
                        "}\n" +


                        "[data-apj-filter-root] .apj-table-column-filter-input::placeholder {\n" +
                        "  color: var(--Text-secondary, #94a3b8);\n" +
                        "}\n" +


                        "[data-apj-filter-root] .apj-table-column-filter-input:focus {\n" +
                        "  border-color: var(--Primaire-blue-main-color, #818cf8);\n" +
                        "  box-shadow: 0 0 0 3px rgba(129,140,248,.2);\n" +
                        "}\n" +


                        "[data-apj-filter-root] .apj-table-column-filter-cancel {\n" +
                        "  position: absolute;\n" +
                        "  right: 3px;\n" +
                        "  display: inline-grid;\n" +
                        "  width: 25px;\n" +
                        "  height: 25px;\n" +
                        "  place-items: center;\n" +
                        "  padding: 0;\n" +
                        "  border: 0;\n" +
                        "  border-radius: 50%;\n" +
                        "  background: transparent;\n" +
                        "  color: var(--Text-secondary, #64748b);\n" +
                        "  cursor: pointer;\n" +
                        "  font-size: 17px;\n" +
                        "  line-height: 1;\n" +
                        "}\n" +


                        "[data-apj-filter-root] .apj-table-column-filter-cancel:hover,\n" +
                        "[data-apj-filter-root] .apj-table-column-filter-cancel:focus-visible {\n" +
                        "  background: var(--Background-tertiaire, #eef2f7);\n" +
                        "  color: var(--Text-primary, #1e293b);\n" +
                        "  outline: 0;\n" +
                        "}\n" +


                        "[data-apj-filter-root] tbody tr.apj-table-filter-row-hidden {\n" +
                        "  display: none !important;\n" +
                        "}\n";


                    document.head.appendChild(style);

                }


                /* ========================================= */
                /* ICON                                      */
                /* ========================================= */

                const SEARCH_ICON =
                    '<svg viewBox="0 0 24 24" class="icon" aria-hidden="true">' +
                    '<circle cx="11" cy="11" r="6.5"></circle>' +
                    '<line x1="16" y1="16" x2="21" y2="21"></line>' +
                    '</svg>';


                let instanceSequence = 0;



                /* ========================================= */
                /* CLASS                                     */
                /* ========================================= */

                class CumulativeTableFilter {


                    constructor(root, table) {

                        this.root = root;
                        this.table = table;

                        this.instanceId = ++instanceSequence;

                        this.filters = new Map();

                        this.openColumnKey = null;

                        this.cellValueCache = new WeakMap();

                        this.refreshScheduled = false;

                        this.checkAll = table.querySelector("[data-check-all]");


                        /*
                         * IMPORTANT
                         *
                         * Le label vient maintenant du
                         * data-apj-filter-label.
                         *
                         * On ne lit plus header.textContent.
                         *
                         * Donc :
                         *
                         * Libelle + swap_vert
                         *
                         * ne devient plus :
                         *
                         * "Libelle swap_vert"
                         */

                        this.columns = Array
                            .from(table.tHead.rows[0].cells)
                            .map((header, cellIndex) => {

                                if (
                                    !header.hasAttribute(
                                        "data-apj-filter-column"
                                    )
                                ) {
                                    return null;
                                }


                                return {

                                    key:
                                        "column-" +
                                        cellIndex,

                                    label:
                                        header.getAttribute(
                                            "data-apj-filter-label"
                                        ) || "",

                                    cellIndex:
                                    cellIndex,

                                    header:
                                    header

                                };

                            })
                            .filter(Boolean);


                        this.installHeaderFilters();

                        this.bindEvents();

                        this.observeTable();

                        this.applyFilters();

                    }



                    /* ===================================== */
                    /* HEADER                                */
                    /* ===================================== */

                    installHeaderFilters() {

                        this.columns.forEach(
                            (column, index) => {


                                const header =
                                    column.header;


                                /*
                                 * Ici on récupère uniquement
                                 * le contenu métier initial :
                                 *
                                 * <a>
                                 *    Libelle
                                 *    swap_vert
                                 * </a>
                                 */

                                const originalContent =
                                    Array.from(
                                        header.childNodes
                                    );


                                const control =
                                    document.createElement(
                                        "div"
                                    );


                                const summary =
                                    document.createElement(
                                        "div"
                                    );


                                const label =
                                    document.createElement(
                                        "span"
                                    );


                                const toggle =
                                    document.createElement(
                                        "button"
                                    );


                                const editor =
                                    document.createElement(
                                        "div"
                                    );


                                const input =
                                    document.createElement(
                                        "input"
                                    );


                                const cancel =
                                    document.createElement(
                                        "button"
                                    );


                                const inputId =
                                    "apj-table-column-filter-" +
                                    this.instanceId +
                                    "-" +
                                    index;



                                control.className =
                                    "apj-table-column-filter";

                                control.dataset.apjColumnFilter =
                                    column.key;



                                summary.className =
                                    "apj-table-column-filter-summary";



                                label.className =
                                    "apj-table-column-filter-label";


                                originalContent.forEach(
                                    (node) => {
                                        label.appendChild(node);
                                    }
                                );



                                /* SEARCH BUTTON */

                                toggle.type =
                                    "button";

                                toggle.className =
                                    "apj-table-column-filter-toggle";

                                toggle.dataset.apjColumnFilterToggle =
                                    column.key;

                                toggle.setAttribute(
                                    "aria-label",
                                    "Filtrer " +
                                    column.label
                                );

                                toggle.setAttribute(
                                    "aria-controls",
                                    inputId
                                );

                                toggle.setAttribute(
                                    "aria-expanded",
                                    "false"
                                );

                                toggle.setAttribute(
                                    "aria-pressed",
                                    "false"
                                );


                                toggle.insertAdjacentHTML(
                                    "beforeend",
                                    SEARCH_ICON
                                );


                                summary.append(
                                    label,
                                    toggle
                                );



                                /* EDITOR */

                                editor.className =
                                    "apj-table-column-filter-editor";

                                editor.hidden =
                                    true;



                                /* INPUT */

                                input.id =
                                    inputId;

                                input.type =
                                    "text";

                                input.className =
                                    "apj-table-column-filter-input";

                                input.dataset.apjColumnFilterInput =
                                    column.key;

                                input.placeholder =
                                    column.label;

                                input.autocomplete =
                                    "off";

                                input.spellcheck =
                                    false;

                                input.setAttribute(
                                    "aria-label",
                                    "Filtrer " +
                                    column.label
                                );



                                /* CANCEL */

                                cancel.type =
                                    "button";

                                cancel.className =
                                    "apj-table-column-filter-cancel";

                                cancel.dataset.apjColumnFilterCancel =
                                    column.key;

                                cancel.setAttribute(
                                    "aria-label",
                                    "Fermer le filtre " +
                                    column.label
                                );

                                cancel.textContent =
                                    "\u00d7";



                                editor.append(
                                    input,
                                    cancel
                                );


                                control.append(
                                    summary,
                                    editor
                                );


                                header.replaceChildren(
                                    control
                                );


                                column.control =
                                    control;

                                column.toggle =
                                    toggle;

                                column.editor =
                                    editor;

                                column.input =
                                    input;

                                column.cancel =
                                    cancel;


                            }
                        );

                    }



                    /* ===================================== */
                    /* EVENTS                                */
                    /* ===================================== */

                    bindEvents() {


                        this.columns.forEach(
                            (column) => {


                                column.toggle.addEventListener(
                                    "click",
                                    (event) => {


                                        event.preventDefault();

                                        event.stopPropagation();


                                        if (
                                            this.openColumnKey ===
                                            column.key
                                        ) {

                                            this.closeEditor(
                                                column.key,
                                                false
                                            );

                                        } else {

                                            this.openEditor(
                                                column.key
                                            );

                                        }

                                    }
                                );



                                column.input.addEventListener(
                                    "input",
                                    () => {

                                        this.updateFilter(
                                            column
                                        );

                                    }
                                );



                                column.input.addEventListener(
                                    "keydown",
                                    (event) => {

                                        if (
                                            event.key !==
                                            "Escape"
                                        ) {
                                            return;
                                        }


                                        event.preventDefault();


                                        this.closeEditor(
                                            column.key,
                                            true
                                        );

                                    }
                                );



                                column.cancel.addEventListener(
                                    "click",
                                    (event) => {


                                        event.preventDefault();

                                        event.stopPropagation();


                                        /*
                                         * Si input vide :
                                         * ferme seulement.
                                         */

                                        if (
                                            this.normalize(
                                                column.input.value
                                            ) === ""
                                        ) {

                                            this.closeEditor(
                                                column.key,
                                                true
                                            );

                                            return;

                                        }


                                        /*
                                         * Sinon :
                                         * reset filtre.
                                         */

                                        column.input.value =
                                            "";


                                        this.updateFilter(
                                            column
                                        );


                                        column.input.focus();


                                    }
                                );


                            }
                        );



                        this.handleDocumentClick =
                            (event) => {


                                const column =
                                    this.getColumn(
                                        this.openColumnKey
                                    );


                                if (
                                    column &&
                                    !column.control.contains(
                                        event.target
                                    )
                                ) {

                                    this.closeEditor(
                                        column.key,
                                        false
                                    );

                                }

                            };



                        this.handleDocumentKeydown =
                            (event) => {


                                if (
                                    event.key ===
                                    "Escape" &&
                                    this.openColumnKey
                                ) {

                                    this.closeEditor(
                                        this.openColumnKey,
                                        true
                                    );

                                }

                            };


                        document.addEventListener(
                            "click",
                            this.handleDocumentClick
                        );


                        document.addEventListener(
                            "keydown",
                            this.handleDocumentKeydown
                        );

                    }



                    /* ===================================== */
                    /* OPEN                                  */
                    /* ===================================== */

                    openEditor(columnKey) {


                        const column =
                            this.getColumn(
                                columnKey
                            );


                        if (!column) {
                            return;
                        }


                        if (
                            this.openColumnKey &&
                            this.openColumnKey !==
                            columnKey
                        ) {

                            this.closeEditor(
                                this.openColumnKey,
                                false
                            );

                        }


                        this.openColumnKey =
                            columnKey;


                        column.editor.hidden =
                            false;


                        column.control.classList.add(
                            "is-editing"
                        );


                        column.toggle.setAttribute(
                            "aria-expanded",
                            "true"
                        );


                        column.input.focus();

                        column.input.select();

                    }



                    /* ===================================== */
                    /* CLOSE                                 */
                    /* ===================================== */

                    closeEditor(
                        columnKey,
                        restoreFocus
                    ) {


                        const column =
                            this.getColumn(
                                columnKey
                            );


                        if (!column) {
                            return;
                        }


                        column.editor.hidden =
                            true;


                        column.control.classList.remove(
                            "is-editing"
                        );


                        column.toggle.setAttribute(
                            "aria-expanded",
                            "false"
                        );


                        if (
                            this.openColumnKey ===
                            columnKey
                        ) {

                            this.openColumnKey =
                                null;

                        }


                        if (restoreFocus) {

                            column.toggle.focus();

                        }

                    }



                    /* ===================================== */
                    /* UPDATE FILTER                         */
                    /* ===================================== */

                    updateFilter(column) {


                        const value =
                            column.input.value;


                        const active =
                            this.normalize(value) !==
                            "";


                        if (active) {

                            this.filters.set(
                                column.key,
                                {
                                    value:
                                    value
                                }
                            );

                        } else {

                            this.filters.delete(
                                column.key
                            );

                        }


                        column.control.classList.toggle(
                            "is-active",
                            active
                        );


                        column.header.classList.toggle(
                            "is-filter-active",
                            active
                        );


                        column.toggle.setAttribute(
                            "aria-pressed",
                            String(active)
                        );


                        column.cancel.setAttribute(
                            "aria-label",
                            (
                                active
                                    ? "Effacer"
                                    : "Fermer"
                            ) +
                            " le filtre " +
                            column.label
                        );


                        this.applyFilters();

                    }



                    /* ===================================== */
                    /* TABLE OBSERVER                        */
                    /* ===================================== */

                    observeTable() {


                        this.observer =
                            new MutationObserver(
                                () => {


                                    this.cellValueCache =
                                        new WeakMap();


                                    if (
                                        this.refreshScheduled
                                    ) {
                                        return;
                                    }


                                    this.refreshScheduled =
                                        true;


                                    requestAnimationFrame(
                                        () => {


                                            this.refreshScheduled =
                                                false;


                                            this.applyFilters();


                                        }
                                    );

                                }
                            );


                        this.observer.observe(
                            this.table,
                            {

                                attributes:
                                    true,

                                attributeFilter: [
                                    "data-filter-value",
                                    "data-filter-ignore"
                                ],

                                childList:
                                    true,

                                characterData:
                                    true,

                                subtree:
                                    true

                            }
                        );

                    }



                    /* ===================================== */
                    /* APPLY                                 */
                    /* ===================================== */

                    applyFilters() {


                        const activeFilters =
                            Array
                                .from(
                                    this.filters.entries()
                                )
                                .map(
                                    ([columnKey, filter]) => ({
                                        column:
                                            this.getColumn(
                                                columnKey
                                            ),

                                        normalizedValue:
                                            this.normalize(
                                                filter.value
                                            )
                                    })
                                )
                                .filter(
                                    (filter) =>
                                        filter.column &&
                                        filter.normalizedValue
                                );


                        this.getDataRows().forEach(
                            (row) => {


                                const matches =
                                    activeFilters.every(
                                        (filter) => {


                                            const value =
                                                this.getCellValue(
                                                    row,
                                                    filter.column
                                                );


                                            return this
                                                .normalize(
                                                    value
                                                )
                                                .includes(
                                                    filter.normalizedValue
                                                );

                                        }
                                    );


                                this.setRowVisibility(
                                    row,
                                    matches
                                );


                            }
                        );

                    }



                    /* ===================================== */
                    /* ROW VISIBILITY                        */
                    /* ===================================== */

                    setRowVisibility(
                        row,
                        visible
                    ) {


                        row.classList.toggle(
                            "apj-table-filter-row-hidden",
                            !visible
                        );


                        /*
                         * Gestion éventuelle des lignes
                         * collapse / détail.
                         */

                        let detailRow =
                            row.nextElementSibling;


                        while (
                            this.isDetailRow(
                                detailRow
                            )
                            ) {


                            detailRow.classList.toggle(
                                "apj-table-filter-row-hidden",
                                !visible
                            );


                            detailRow =
                                detailRow.nextElementSibling;


                        }

                    }



                    /* ===================================== */
                    /* DETAIL ROW                            */
                    /* ===================================== */

                    isDetailRow(row) {


                        if (!row) {
                            return false;
                        }


                        if (
                            row.hasAttribute(
                                "data-apj-filter-detail-row"
                            ) ||
                            row.classList.contains(
                                "collapse"
                            )
                        ) {

                            return true;

                        }


                        const firstCell =
                            row.cells[0];


                        return (
                            row.cells.length ===
                            1 &&
                            firstCell &&
                            firstCell.classList.contains(
                                "collapse-container"
                            )
                        );

                    }



                    /* ===================================== */
                    /* DATA ROWS                             */
                    /* ===================================== */

                    getDataRows() {


                        const rows =
                            [];


                        Array
                            .from(
                                this.table.tBodies
                            )
                            .forEach(
                                (tbody) => {


                                    Array
                                        .from(
                                            tbody.rows
                                        )
                                        .forEach(
                                            (row) => {


                                                if (
                                                    !this.isDetailRow(
                                                        row
                                                    )
                                                ) {

                                                    rows.push(
                                                        row
                                                    );

                                                }


                                            }
                                        );

                                }
                            );


                        return rows;

                    }



                    /* ===================================== */
                    /* CELL                                  */
                    /* ===================================== */

                    getCellValue(
                        row,
                        column
                    ) {


                        let rowCache =
                            this.cellValueCache.get(
                                row
                            );


                        if (!rowCache) {

                            rowCache =
                                new Map();


                            this.cellValueCache.set(
                                row,
                                rowCache
                            );

                        }


                        if (
                            rowCache.has(
                                column.key
                            )
                        ) {

                            return rowCache.get(
                                column.key
                            );

                        }


                        const cell =
                            row.cells[
                                column.cellIndex
                                ];


                        const value =
                            cell
                                ? this.extractBusinessText(
                                    cell
                                )
                                : "";


                        rowCache.set(
                            column.key,
                            value
                        );


                        return value;

                    }



                    /* ===================================== */
                    /* BUSINESS TEXT                         */
                    /* ===================================== */

                    extractBusinessText(cell) {


                        const explicitElement =
                            cell.hasAttribute(
                                "data-filter-value"
                            )
                                ? cell
                                : cell.querySelector(
                                    "[data-filter-value]"
                                );


                        if (explicitElement) {


                            const explicitValue =
                                explicitElement.getAttribute(
                                    "data-filter-value"
                                );


                            if (
                                explicitValue &&
                                explicitValue.trim()
                            ) {

                                return explicitValue.trim();

                            }


                            return explicitElement
                                .textContent
                                .replace(
                                    /\s+/g,
                                    " "
                                )
                                .trim();

                        }



                        const clone =
                            cell.cloneNode(
                                true
                            );


                        clone
                            .querySelectorAll(
                                "[data-filter-ignore], script, style, svg, button, input, select, textarea"
                            )
                            .forEach(
                                (element) =>
                                    element.remove()
                            );


                        return clone
                            .textContent
                            .replace(
                                /\s+/g,
                                " "
                            )
                            .trim();

                    }



                    /* ===================================== */
                    /* NORMALIZE                             */
                    /* ===================================== */

                    normalize(value) {


                        return String(
                            value || ""
                        )
                            .normalize(
                                "NFD"
                            )
                            .replace(
                                /[\u0300-\u036f]/g,
                                ""
                            )
                            .toLocaleLowerCase(
                                "fr"
                            )
                            .replace(
                                /\s+/g,
                                " "
                            )
                            .trim();

                    }



                    /* ===================================== */
                    /* GET COLUMN                            */
                    /* ===================================== */

                    getColumn(columnKey) {


                        return this.columns.find(
                            (column) =>
                                column.key ===
                                columnKey
                        );

                    }



                    /* ===================================== */
                    /* REFRESH                               */
                    /* ===================================== */

                    refresh() {


                        this.cellValueCache =
                            new WeakMap();


                        this.applyFilters();

                    }


                }



                /* ========================================= */
                /* API                                       */
                /* ========================================= */

                const instances =
                    new WeakMap();


                const api = {


                    initAll:
                        function (scope) {


                            const roots =
                                [];


                            if (
                                scope.matches &&
                                scope.matches(
                                    "[data-apj-filter-root]"
                                )
                            ) {

                                roots.push(
                                    scope
                                );

                            }


                            if (
                                scope.querySelectorAll
                            ) {

                                roots.push(
                                    ...scope.querySelectorAll(
                                        "[data-apj-filter-root]"
                                    )
                                );

                            }


                            roots.forEach(
                                (root) => {


                                    if (
                                        instances.has(
                                            root
                                        )
                                    ) {

                                        return;

                                    }


                                    const table =
                                        root.querySelector(
                                            "table[data-apj-filter-table]"
                                        );


                                    if (
                                        !table ||
                                        !table.tHead ||
                                        !table.tHead.rows.length ||
                                        !table.tBodies.length
                                    ) {

                                        return;

                                    }


                                    instances.set(
                                        root,
                                        new CumulativeTableFilter(
                                            root,
                                            table
                                        )
                                    );


                                }
                            );


                        },


                    getInstance:
                        function (root) {


                            return (
                                instances.get(
                                    root
                                ) ||
                                null
                            );

                        }


                };


                window.ApjDataTableFilter =
                    api;


                api.initAll(
                    document
                );



                /*
                 * Support des tableaux éventuellement
                 * injectés dynamiquement.
                 */

                const documentObserver =
                    new MutationObserver(
                        (mutations) => {


                            if (
                                mutations.some(
                                    (mutation) =>
                                        mutation
                                            .addedNodes
                                            .length >
                                        0
                                )
                            ) {

                                api.initAll(
                                    document
                                );

                            }

                        }
                    );


                documentObserver.observe(
                    document.documentElement,
                    {
                        childList:
                            true,

                        subtree:
                            true
                    }
                );


            })(window, document);

        </script>


        <%
            out.println(
                    pr.getBasPage()
            );
        %>
    </section>
</div>
<%
    }
    catch (Exception e) {

        e.printStackTrace();
    }
%>