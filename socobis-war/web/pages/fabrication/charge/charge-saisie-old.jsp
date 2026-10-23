<%@page import="charge.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%
    try{

        PageInsert pi =null;
        Liste[] liste = null;
        String titre = "Charge";
        String classe = "charge.Charge";

        Charge a = new Charge();
        pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        liste = new Liste[1];
        TypeObjet typeC = new TypeObjet();
        typeC.setNomTable("typecharge");
        liste[0] = new Liste("type", typeC, "val", "id");
        pi.getFormu().changerEnChamp(liste);
        titre = "Charge";
        classe = "charge.Charge";

        if(request.getParameter("id") != null){
            pi.getFormu().getChamp("idfabrication").setDefaut(request.getParameter("id"));
        }
        pi.getFormu().getChamp("idingredients").setPageAppelComplete("produits.Ingredients","id","as_ingredients");
        pi.getFormu().getChamp("idingredients").setLibelle("Ingredient");
        pi.getFormu().getChamp("libelle").setLibelle("Description");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("pu").setLibelle("Prix");
        pi.getFormu().getChamp("qte").setLibelle("Quantit&eacute;");
        pi.getFormu().getChamp("type").setLibelle("Tye de charge");
        pi.getFormu().getChamp("idfabrication").setLibelle("Fabrication");
        pi.getFormu().getChamp("idfabrication").setAutre("readonly");
        pi.getFormu().getChamp("etat").setVisible(false);
        String idfabrication=pi.getFormu().getChamp("idfabrication").getValeur();

        String[] ordre = {"idfabrication","daty","libelle","type","idingredients","qte","pu","etat"};
        pi.getFormu().setOrdre(ordre);

        String butApresPost = "fabrication/fabrication-fiche.jsp&id="+idfabrication+"&tab=inc/fabrication-charge";
        String nomTable = "charge";
        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
%>
<div class="content-wrapper">
    <h1 align="center">Saisie <%=titre%></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post"  data-parsley-validate>
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>
