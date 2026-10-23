<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="mg.cnaps.compta.ComptaCompte"%>
<%@page import="mg.cnaps.compta.TypeCompte"%>
<%@page import="affichage.*"%>
<%@ page import="user.*" %>
<%@ page import="mg.cnaps.compta.ConstanteCompta" %>
<%@ page import="utils.ConstanteSavonnerie" %>

<%
    try {

        UserEJB u = null;
        u = (UserEJB) session.getAttribute("u");
        String user = u.getUser().getLoginuser();
        ComptaCompte da = new ComptaCompte();
        da.setNomTable("compta_compte");
        PageInsert pi = new PageInsert(da, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));

        affichage.Champ[] liste = new affichage.Champ[1];
        TypeObjet c = new TypeObjet();
        c.setNomTable("COMPTA_JOURNAL_VIEW");
        liste[0] = new Liste("idjournal", c, "desce", "id");
        liste[0].ajouterVide();

        //TypeObjet typecompte = new TypeObjet();
        //typecompte.setNomTable("COMPTA_TYPE_COMPTE");
//        String[] valeur = {"0","1"};
//        String[] affiche = {"NON","OUI"};
//        liste[1] = new Liste("analytique_obli",affiche,valeur);
        pi.getFormu().getChamp("analytique_obli").setDefaut("0");
        pi.getFormu().getChamp("analytique_obli").setVisible(false);
        pi.getFormu().getChamp("compte").setLibelle("Compte");
        pi.getFormu().getChamp("libelle").setLibelle("Libell&eacute;");
        pi.getFormu().getChamp("classy").setLibelle("Classe");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idjournal").setLibelle("Code Journal");
        pi.getFormu().getChamp("typeCompte").setVisible(false);
        pi.getFormu().getChamp("typeCompte").setDefaut(ConstanteSavonnerie.COMPTA_TYPE_COMPTE_AUXILIAIRE);
        pi.getFormu().getChamp("analytique_obli").setLibelle("Analytique");
        //pi.getFormu().getChamp("classy").setPageAppelComplete("bean.TypeObjet","id","compta_classe_compte","","");
        pi.getFormu().getChamp("classy").setVisible(false);
        pi.preparerDataFormu();

        pi.getFormu().makeHtmlInsertTabIndex();
    %>
    <div class="content-wrapper">
        <section class="content">
            <h1 class="title">Plan Auxiliaire</h1>
            <form  action="<%= pi.getLien() %>?but=apresTarif.jsp" method="post" name="compte" id="compte" data-parsley-validate>
                 <div class="col-md-12 mb-5 nopadding">
                <%
                    out.println(pi.getFormu().getHtmlInsert());
                %>
                </div>
                <input name="acte" type="hidden" id="nature" value="insert">
                <input name="bute" type="hidden" id="bute" value="compta/compte/compte-auxiliaire-liste.jsp">
                <input name="classe" type="hidden" id="classe" value="mg.cnaps.compta.ComptaCompte">
            </form>
    <%
    ComptaCompte lv = new ComptaCompte();
    lv.setNomTable("compta_compte_libelle");
    String listeCrt[] = {"id", "compte", "libelle","idtypecompte"};
    String listeInt[] = null;
    String libEntete[] = {"id", "compte", "libelle","typecompte"};
    PageRecherche pr = new PageRecherche(lv, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.getFormu().getChamp("libelle").setLibelle("Libelle");
    pr.getFormu().getChamp("idtypecompte").setVisible(false);
    //    pr.getFormu().getChamp("compte").setRecherchePrecis(true);
    new ChampCompteRecherchePrecis("compte", pr.getFormu());


        //    affichage.Champ[] liste = new affichage.Champ[1];
//    TypeObjet c = new TypeObjet();
//    c.setNomTable("COMPTA_JOURNAL_VIEW");
//    liste[0] = new Liste("idjournal", c, "desce", "desce");

//    pr.getFormu().changerEnChamp(liste);
//    pr.getFormu().getChamp("idjournal").setLibelle("Journal");

//    affichage.Champ[] listef = new affichage.Champ[1];
//    TypeCompte liste0 = new TypeCompte();
//    liste0.setNomTable("compta_type_compte");
//    listef[0] = new Liste("idtypecompte",liste0,"val","id");
//    pr.getFormu().changerEnChamp(listef);
//    pr.getFormu().getChamp("idtypecompte").setLibelle("Type de compte");
    pr.getFormu().getChamp("id").setLibelle("R&eacute;f.");
    pr.setNpp(50);

    pr.setAWhere("and idtypecompte = '" + ConstanteSavonnerie.COMPTA_TYPE_COMPTE_AUXILIAIRE + "'");
    pr.setOrdre(" order by compte asc");
    pr.setApres("compta/compte/compte-auxiliaire-liste.jsp");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
%>
   <br>
    <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="incident" id="incident">
            <%
               out.println(pr.getFormu().getHtmlEnsemble());
            %>
    </form>
    <%
        String lienTableau[] = {pr.getLien() + "?but=compta/compte/compte-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        out.println(pr.getTableauRecap().getHtml());
    %>
    <br>
        <%
            String libEnteteAffiche[] = {"R&eacute;f.", "Compte", "Libell&eacute;","Type de compte"};
            pr.getTableau().setLibelleAffiche(libEnteteAffiche);
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
        throw e;
    }
%>