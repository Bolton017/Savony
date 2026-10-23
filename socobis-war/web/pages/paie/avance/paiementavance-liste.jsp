<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="paie.avance.Remboursement"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="paie.avance.PaiementAvance" %>
<%@ page import="paie.avance.PaiementAvanceLib" %>
<%@ page import="utilitaire.ConstanteEtat" %>

<%
    try{
        PaiementAvanceLib lv = new PaiementAvanceLib();
        lv.setNomTable("PAIEMENTAVANCELIB");


        String listeCrt[] = {"id","idavance","typeavancelib","moisLib", "annee", "montant","etat"};
        String listeInt[] = {"annee","montant"};
        String libEntete[] ={"idavance","id","typeavancelib","moisLib", "annee", "montant","modepaiement","datepaiement","etatlib"};
        String libEnteteAffiche[] =  { "Avance","id","Type de l'avance","mois", "ann&eacute;e", "montant","Mode de paiement","Date de paiement","&Eacute;tat"};
        PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        Liste [] liste = new Liste[2];
        Liste l1 = new Liste("etat");
        l1.setLibelle("&Eacute;tat");
        String etatVal[] = new String[]{"%","1","11"};
        String etatCol[] = new String[]{"Tous","CR&Eacute;E","VALID&Eacute;E"};
        l1.setValeurBrute(etatCol);
        l1.setColValeurBrute(etatVal);
        liste[0] = l1;
        Liste l2 = new Liste("moisLib");
        String[] mois = {
                "%",
                "Janvier",
                "F&eacute;vrier",
                "Mars",
                "Avril",
                "Mai",
                "Juin",
                "Juillet",
                "Ao&ucirc;t",
                "Septembre",
                "Octobre",
                "Novembre",
                "D&eacute;cembre"
        };
        String[] moisCol = {
                "Tous",
                "Janvier",
                "F&eacute;vrier",
                "Mars",
                "Avril",
                "Mai",
                "Juin",
                "Juillet",
                "Ao&ucirc;t",
                "Septembre",
                "Octobre",
                "Novembre",
                "D&eacute;cembre"
        };
        l2.setValeurBrute(moisCol);
        l2.setColValeurBrute(mois);
        liste[1] = l2;
        pr.getFormu().changerEnChamp(liste);
        pr.getFormu().getChamp("idavance").setLibelle("Id Avance");
        pr.getFormu().getChamp("moisLib").setLibelle("mois");
        pr.getFormu().getChamp("annee1").setLibelle("ann&eacute;e (min)");
        pr.getFormu().getChamp("annee2").setLibelle("ann&eacute;e (max)");
        pr.getFormu().getChamp("montant1").setLibelle("montant (min)");
        pr.getFormu().getChamp("montant2").setLibelle("montant (max)");
        pr.getFormu().getChamp("typeavancelib").setLibelle("Type de l'avance");
        pr.getFormu().getChamp("etat").setLibelle("&Eacute;tat");

        pr.setApres("paie/avance/paiementavance-liste.jsp");
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);%>
<script>
    function changerDesignation() {
        document.listeRemboursement.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des paiements d'avances</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/avance/paiementavance-liste.jsp" method="post" name="listeRemboursement" id="listeRemboursement">
            <%

                out.println(pr.getFormu().getHtmlEnsemble());

            %>
        </form>
        <%  String lienTableau[] = {pr.getLien() + "?but=paie/avance/paiementavance-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());%>
        </br>
        <%

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
