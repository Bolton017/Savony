

<%@ page import="utils.*" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="paiement.*" %>
<%@ page import="vente.*" %>
<%
    try{
    String idvente = request.getParameter("idvente"); 
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");    
    LiaisonPaiement pf = null;
    if (idvente != null && !idvente.equalsIgnoreCase("")) {
            pf = Vente.genererPaiementFactureParAvoir(u.getUser().getTuppleID(), null, idvente);
    }   
    LiaisonPaiement a = new LiaisonPaiement();
    PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));
    //Modification des affichages
    pi.getFormu().getChamp("id1").setLibelle("ID Facture avoir");
    pi.getFormu().getChamp("id2").setLibelle("ID Facture vente");
    pi.getFormu().getChamp("montant").setLibelle("Montant");
    //pi.getFormu().getChamp("montant").setAutre("readonly");
    pi.getFormu().getChamp("id2").setPageAppel("choix/vente/vente-choix.jsp");
    pi.getFormu().getChamp("id1").setPageAppel("choix/avoir/avoirfc-choix-multiple.jsp");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("id1").setAutre("readonly");
    pi.getFormu().getChamp("id2").setAutre("readonly");
    if (pf != null)
    {
        pi.getFormu().setDefaut(pf);
    }
    //Variables de navigation
    String classe = "vente.PaiementFacture";
    String butApresPost = "vente/vente-fiche.jsp";
    String nomTable = "paiementfacture";
    //Generer les affichages
    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>
<div class="content-wrapper">
    <h1 >Paiement de la facture par avoir</h1>
    
    <form action="<%=pi.getLien()%>?but=vente/apres-paiement.jsp" method="post"  data-parsley-validate>
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input type="hidden" id="idClient" name="idClient">
        <input name="acte" type="hidden" id="nature" value="paiement_facture">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
} %>
<script>
document.addEventListener("DOMContentLoaded", function () {
    var btnAvoir = document.querySelector("input[name='choix'][onclick*='avoirfc-choix-multiple.jsp']");
    
    if (btnAvoir) {
        btnAvoir.onclick = function () {
            var idClient = document.getElementById("idClient").value;
            var url = "choix/avoir/avoirfc-choix-multiple.jsp"
                    + "?idClient=" + encodeURIComponent(idClient)
                    + "&champReturn=id1;id1libelle"
                    + "&apresLienPageAppel=";

            pagePopUp(url);
        };
    }
});
</script>
