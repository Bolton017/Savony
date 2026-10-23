<%@ page import="affichage.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="user.*" %>
<%@ page import="paie.elementpaie.PaieInfoPersEltPaieComplet" %>
<%
    try {

        PaieInfoPersEltPaieComplet lv = new PaieInfoPersEltPaieComplet();
        lv.setNomTable("paie_edition_libcomplet");

        String listeCrt[] = {"id","idpersonnellib","idelementpaielib", "matricule", "mois", "annee","datedebut","datefin"};
        String listeInt[] = {"mois", "annee","datedebut","datefin"};

        String[] pourcentage = {};
        //String colDefaut[] = {"id","idpersonnellib","idelementpaielib", "matricule", "mois", "annee","datedebut","datefin"};
        String somDefaut[] = {"gain","retenue"};

        String[] colGr = {"idelementpaielib"};
        String[] colGrCol = {"moislib","annee"};

        PageRechercheGroupe pr = new PageRechercheGroupe(lv, request, listeCrt, listeInt, 3, colGr, somDefaut, pourcentage, colGr.length, somDefaut.length);
//        PageRechercheGroupe pr = new PageRechercheGroupe(lv, request, listeCrt, listeInt, 3, colDefaut, somDefaut, pourcentage, colDefaut.length, somDefaut.length);
//        PageRechercheGroupe pr = new PageRechercheGroupe(o, req, vrt, listInterval, nbRange, colGr, sommGr, pourc, nbCol, somGr)
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        //pr.getFormu().getChamp("mois2").setDefaut(((utilitaire.Utilitaire.getMoisEnCours()+1)+""));
        //pr.getFormu().getChamp("annee2").setDefaut((utilitaire.Utilitaire.getAnneeEnCours()+""));


        pr.getFormu().getChamp("mois1").setLibelle("Mois Min");
        pr.getFormu().getChamp("mois2").setLibelle("Mois Max");

        pr.getFormu().getChamp("annee1").setLibelle("Ann&eacute;e Min");
        pr.getFormu().getChamp("annee2").setLibelle("Ann&eacute;e Max");

        pr.getFormu().getChamp("datedebut1").setLibelle("date de d&eacute;but Min");
        pr.getFormu().getChamp("datedebut2").setLibelle("date de d&eacute;but Max");

        pr.getFormu().getChamp("datefin1").setLibelle("date de fin Min");
        pr.getFormu().getChamp("datefin2").setLibelle("date de fin Max");

        pr.getFormu().getChamp("idpersonnellib").setLibelle("Nom de l'employ&eacute;");
        pr.getFormu().getChamp("idelementpaielib").setLibelle("Rubrique de paie");

        pr.setApres("paie/editions/paieedition-analyse3.jsp");


        //pr.creerObjetPagePourc();
        pr.setNpp(1000);

        pr.creerObjetPageCroise(colGrCol,pr.getLien()+"?but=");


%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Analyse &eacute;dition</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%=pr.getApres()%>" method="post" name="analyse" id="analyse">
            <%out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <%
            String lienTableau[] = {pr.getLien() + "?but=paie/editions/paieedition-fiche.jsp"};
            String colonneLien[] = {"id"};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(colonneLien);
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            String libEnteteAffiche[] = {"id","Nom","element paie", "matricule", "mois", "annee","code rubrique","date debut","date fin","gain","retenue"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            //out.println(pr.getBasPage());
        %>
    </section>
</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>