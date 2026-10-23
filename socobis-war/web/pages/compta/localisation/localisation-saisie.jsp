<%-- 
    Document   : Localisation-saisie
    Description: Saisie d'une localisation
--%>

<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%@page import="mg.cnaps.compta.Localisation"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%
try{

    UserEJB u = (UserEJB) session.getAttribute("u");
    String user = u.getUser().getLoginuser();

    Localisation da = new Localisation();
    da.setNomTable("localisation");

    PageInsert pi = new PageInsert(da, request, u);

    pi.setLien((String) session.getAttribute("lien"));
//    Liste[] liste = new Liste[1];
//    TypeObjet liste0 = new TypeObjet();
//    liste0.setNomTable("DEPARTEMENT");
//    liste[0] = new Liste("departement",liste0,"val","id");
//    pi.getFormu().changerEnChamp(liste);

    /*
    champs liste déroulante pour typeCompte
    */
//    affichage.Champ[] liste = new affichage.Champ[1];
//
//    TypeObjet typecompte = new TypeObjet();
//    typecompte.setNomTable("COMPTA_TYPE_COMPTE");


    pi.getFormu().getChamp("compte").setLibelle("Emplacement");
    // liste[0] = new Liste("typeCompte", typecompte, "val", "id");

    /*
    configuration champs
    */
    pi.getFormu().getChamp("libelle").setLibelle("Libell&eacute;");
    pi.getFormu().getChamp("classy").setLibelle("Magasin");
    pi.getFormu().getChamp("classy").setPageAppelComplete("magasin.Magasin","id","magasin2");
    pi.getFormu().getChamp("departement").setVisible(false);
    pi.getFormu().getChamp("classy").setPageAppelComplete("magasin.Magasin","id","magasin2","","");
        
    //pi.getFormu().getChamp("classy").setVisible(false);

    /*
    cacher champs inutiles
    */
    if(pi.getFormu().getChamp("idjournal") != null)
        pi.getFormu().getChamp("idjournal").setVisible(false);

    if(pi.getFormu().getChamp("analytique_obli") != null)
        pi.getFormu().getChamp("analytique_obli").setVisible(false);

    /*
    liste déroulante type compte
    */
    // pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("typeCompte").setLibelle("Type de compte");
    pi.getFormu().getChamp("typeCompte").setVisible(false);

    /*
    preparer formulaire
    */
    pi.preparerDataFormu();

    pi.getFormu().makeHtmlInsertTabIndex();

%>

<div class="content-wrapper">

    <h1 class="title">Saisie d'un emplacement</h1>

    <form class="col-12"
          action="<%= pi.getLien() %>?but=apresTarif.jsp"
          method="post"
          name="localisation"
          id="localisation"
          data-parsley-validate>

        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>

        <input name="acte" type="hidden" value="insert">

        <input name="bute" type="hidden"
               value="compta/localisation/localisation-fiche.jsp">

        <input name="classe" type="hidden"
               value="mg.cnaps.compta.Localisation">

    </form>

</div>

<%
}
catch (Exception e)
{
    e.printStackTrace();
}
%>