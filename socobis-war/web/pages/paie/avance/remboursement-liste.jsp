<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="paie.avance.Remboursement"%>
<%@page import="affichage.PageRecherche"%>

<%
    try{
    Remboursement lv = new Remboursement();
        lv.setNomTable("Remboursementlib");


    String listeCrt[] = {"id","idavance","typeavancelib","matricule","personnel" ,"moisLib", "annee", "montant"};
    String listeInt[] = {"mois","annee","montant"};
    String libEntete[] ={"idavance","id","typeavancelib","matricule","personnel" ,"moisLib", "annee", "montant"};

    PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    pr.getFormu().getChamp("idavance").setLibelle("Id Avance");
    pr.getFormu().getChamp("moisLib").setLibelle("mois");
    pr.getFormu().getChamp("annee1").setLibelle("ann&eacute;e (min)");
    pr.getFormu().getChamp("annee2").setLibelle("ann&eacute;e (max)");
    pr.getFormu().getChamp("montant1").setLibelle("montant (min)");
    pr.getFormu().getChamp("montant2").setLibelle("montant (max)");
    pr.getFormu().getChamp("typeavancelib").setLibelle("Type de l'avance");

    pr.setApres("paie/avance/remboursement-liste.jsp");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);%>
<script>
    function changerDesignation() {
        document.listeRemboursement.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des plans de remboursement</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/avance/remboursement-liste.jsp" method="post" name="listeRemboursement" id="listeRemboursement">
            <%

                out.println(pr.getFormu().getHtmlEnsemble());

            %>
        </form>
        <%  String lienTableau[] = {pr.getLien() + "?but=paie/avance/remboursement-fiche.jsp"};
            String colonneLien[] = {"idavance"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());%>
        </br>
        <%
            String libEnteteAffiche[] =  { "Avance","id","Type de l'avance","matricule","personnel" ,"mois", "ann&eacute;e", "montant"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());

        %>
    </section>
</div>
<%
    }catch(Exception ex){
        ex.printStackTrace();
    }

        %>
