<%@ page import="rapport.utilitaire.ExportJarClassesToJson" %>
<%@ page import="user.UserEJB" %>
<%@ page import="rapport.mapping.CRContent" %>
<%@ page import="rapport.mapping.CRContentFille" %>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    try {
        ExportJarClassesToJson exportJarClassesToJson = new ExportJarClassesToJson();
        String map = exportJarClassesToJson.castJsonToString();
        String[] classNames = exportJarClassesToJson.getClassNames();

        UserEJB u = (UserEJB) session.getValue("u");
        String classeMere = "rapport.mapping.CRContent",
                classeFille = "rapport.mapping.CRContentFille",
                titre = "Configuration du contenus",
                redirection = "rapport/configuration/cr/contenus/config-contenus-fiche.jsp";
        String colonneMere = "idCrContent";

        if(request.getParameter("acte")!=null){
            titre = "Modification du contenus";
        }

        CRContent mere = new CRContent();
        CRContentFille fille = new CRContentFille();

        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, 10, u);
        pi.setLien((String) session.getValue("lien"));
        pi.setUtilisateur(u);

        String[] val = {"0", "1"};
        String[] aff = {"Non", "Oui"};
        affichage.Liste[] listes = new Liste[1];
        listes[0] = new Liste("graphe");
        listes[0].ajouterValeur(val, aff);

        pi.getFormu().changerEnChamp(listes);

        pi.getFormu().getChamp("mapping").setAutre(
                "list=\"classesList\"\n" +
                        "onchange=\"showAttributes();\"");

        affichage.Liste[] listesFille = new Liste[2];
        TypeObjet typeObjet = new TypeObjet();
        typeObjet.setNomTable("OuiNon");
        listesFille[0] = new Liste("colSomme",typeObjet,"val","id");
        listesFille[1] = new Liste("colDate", typeObjet, "val", "id");

        pi.getFormufle().changerEnChamp(listesFille);

        pi.getFormufle().getChamp("libEntete_0").setLibelle("LibEntete");
        pi.getFormufle().getChamp("libEnteteAfficher_0").setLibelle("LibEnteteAfficher");
        pi.getFormufle().getChamp("colSomme_0").setLibelle("ColSomme");
        pi.getFormufle().getChamp("colDate_0").setLibelle("ColDate");
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"), false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idCrContent"), false);
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("colSomme"), "0");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("colDate"), "0");

        affichage.Champ.setAutre(pi.getFormufle().getChampFille("libEntete"), "list=\"attributeList\"");

        pi.preparerDataFormu();

        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=titre%></h1>
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%

            out.println(pi.getFormu().getHtmlInsert());
        %>
        <datalist id="classesList">
            <% for(int i=0; i<classNames.length; i++){ %>
            <option value="<%= classNames[i] %>"></option>
            <% } %>
        </datalist>
        <%
            out.println(pi.getFormufle().getHtmlTableauInsert());

        %>
        <datalist id="attributeList"></datalist>

        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=redirection%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="nomTable" value="CRContentFille">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="10">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
    </form>
</div>

<script>
    <%= map %>

    function showAttributes() {
        const selectedClass = document.getElementById("mapping").value;
        const attributeList = document.getElementById("attributeList");

        // console.log('Selectionner: ', classesMap[selectedClass]);

        attributeList.innerHTML = "";

        if (classesMap[selectedClass]) {
            classesMap[selectedClass].forEach(attr => {
                const option = document.createElement("option");
                option.value = attr;
                attributeList.appendChild(option);
            });
        }
    }
</script>

<%
    } catch (Exception e) {
        out.println("<script>alert('Erreur lors de la lecture du JSON: " + e.getMessage() + "');</script>");
    }
%>
