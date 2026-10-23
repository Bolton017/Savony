<%@page import="caisse.VirementIntraCaisse"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%
    try{
    VirementIntraCaisse a = new VirementIntraCaisse();
    PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Saisie de virement intra-tr&eacute;sorerie");
    //Modification des affichages
    //pi.getFormu().getChamp("id").setVisible(false);
    String[] order = {"daty"};
    Liste[] liste = new Liste[2];
    liste[0] = new Liste("idCaisseDepart",new caisse.CaisseCpl(),"val","id");
    liste[1] = new Liste("idCaisseArrive",new caisse.CaisseCpl(),"val","id");
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("idCaisseDepart").setLibelle("Tr&eacute;sorerie de d&eacute;part");
    pi.getFormu().getChamp("idCaisseArrive").setLibelle("Tr&eacute;sorerie d'arriv&eacute;e");
    pi.getFormu().getChamp("Etat").setVisible(false);
    pi.getFormu().getChamp("idOrigine").setVisible(false);
    pi.getFormu().getChamp("designation").setLibelle("d&eacute;signation");
    pi.getFormu().getChamp("daty").setLibelle("date");
    pi.getFormu().setOrdre(order);
    //Variables de navigation
    String classe = "caisse.VirementIntraCaisse";
    String butApresPost = "caisse/virementIntraCaisse/virementIntraCaisse-fiche.jsp";
    String nomTable = "VirementIntraCaisse";
    //Generer les affichages
    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>
<div class="content-wrapper">
    <h1 align="center">Virement intra tr&eacute;sorerie</h1>
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