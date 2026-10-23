<%@page import="affichage.PageConsulte"%>
<%@page import="paie.avance.Avance"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="paie.avance.Remboursement"%>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.Liste" %>
<%@ page import="affichage.Champ" %>
<%@ page import="bean.TypeObjet" %>

<%
    try {
        String lien = (String) session.getAttribute("lien");
        String id = request.getParameter("id"),
                nb_Remboursement = request.getParameter("nbremboursement"),
                colonneMere = "idAvance",
                classeFille = "paie.avance.Remboursement",
                redirection = "paie/avance/avance-fiche.jsp&id=" + id;

        Avance avance = new Avance();
        avance.setNomTable("AVANCE_LIB");

        PageConsulte pc = new PageConsulte(avance, request, (user.UserEJB) session.getValue("u"));
        pc.getChampByName("daty").setVisible(false);
        pc.getChampByName("idpersonnel").setLibelle("Personnel");
        pc.getChampByName("nbremboursement").setLibelle("Nombre de remboursements");
        pc.getChampByName("dateAvance").setLibelle("Date avance");
        pc.getChampByName("idTypeAvance").setLibelle("Type avance");
        pc.setTitre("Fiche Avance");

        Avance base = (Avance) pc.getBase();
        Remboursement fille = new Remboursement();
        fille.setNomTable("Remboursement");
        int nombreLigne = base.getNbremboursement();
        int nbremboursement = base.getNbremboursement();
        double interet = base.getInteret()/100;
        double montant_int = (base.getMontant()*interet) + base.getMontant();
        int montant = (int) montant_int / nbremboursement;

        UserEJB u = (UserEJB) session.getValue("u");
        PageInsertMultiple pi = new PageInsertMultiple(base, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));

        affichage.Champ[] liste = new Champ[1];
        Liste mois = new Liste("mois", new TypeObjet("MOISCP"), "val", "id");
        liste[0] = mois;
        pi.getFormufle().changerEnChamp(liste);

        pi.getFormufle().getChamp("mois_0").setLibelle("Mois");
        pi.getFormufle().getChamp("annee_0").setLibelle("Ann&eacute;e");
        pi.getFormufle().getChamp("montant_0").setLibelle("Montant");
        pi.getFormufle().getChamp("daty_0").setLibelle("Date");

        pi.getFormufle().getChamp("remarque_0").setVisible(false);
        pi.getFormufle().getChamp("etat_0").setVisible(false);
        pi.getFormufle().getChamp("idavance_0").setVisible(false);

        String remarque = "Remboursement avance: " + base.getId();
        affichage.Champ.setDefaut(pi.getFormufle().getChampMulitple("idavance").getListeChamp(), base.getId());
        affichage.Champ.setDefaut(pi.getFormufle().getChampMulitple("remarque").getListeChamp(), remarque);
        affichage.Champ.setDefaut(pi.getFormufle().getChampMulitple("annee").getListeChamp(), Utilitaire.getAnneeEnCours());
        affichage.Champ.setDefaut(pi.getFormufle().getChampMulitple("montant").getListeChamp(), montant + "");


        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("remarque").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("etat").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idavance").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);

        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

        Remboursement[] lsP = fille.listPlanRemb("", null);
        if (lsP.length > 0) {
%>
<script>document.location.replace("<%=lien%>?but=paie/avance/remboursement-modif.jsp&id=<%=base.getId()%>");</script>
<%
        return;
    }
%>

<div class="content-wrapper">
    <h1 class="box-title">
        <a href="<%= lien + "?but=paie/avance/avance-fiche.jsp&id=" + id %>">
            <i class="fa fa-angle-left"></i>
        </a>Fiche avance
    </h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%= pc.getHtml() %>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="cardradius">
        <div class="box-header">
            <h3 class="box-title h520pxSemibold m-0">Plan de Remboursement</h3>
        </div>
        <form action="<%=lien%>?but=apresTarifMultiple.jsp" method="post" name="remboursement" id="remboursement">
            <%
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>

            <input type="hidden" name="acte" value="savePlanRemboursement">
            <input type="hidden" name="bute" value="<%= redirection %>">
            <input type="hidden" name="idMere" value="<%= base.getId() %>">
            <input type="hidden" name="classefille" value="<%= classeFille %>">
            <input type="hidden" name="nombreLigne" value="<%= nbremboursement %>">
            <input type="hidden" name="colonneMere" value="<%= colonneMere %>">
        </form>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const monthOrder = [1,2,3,4,5,6,7,8,9,10,11,12];
        document.querySelectorAll("select[id^='mois_']").forEach(select => {
            const options = Array.from(select.options);
            options.sort((a, b) => {
                return monthOrder.indexOf(parseInt(a.value))
                    - monthOrder.indexOf(parseInt(b.value));
            });
            select.innerHTML = "";
            options.forEach(opt => select.appendChild(opt));
        });
    });
</script>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script>alert('<%= e.getMessage() %>'); history.back();</script>

<% } %>
