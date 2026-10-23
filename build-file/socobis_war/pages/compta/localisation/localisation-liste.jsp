<%@page import="mg.cnaps.compta.LocalisationLib"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%@page import="affichage.Liste"%>
<%@page import="bean.*"%>
<%@page import="mg.cnaps.compta.*"%>
<%@page import="affichage.PageRecherche"%>

<%
try {

    LocalisationLib lv = new LocalisationLib();

    lv.setNomTable("localisationLib");

    /*
    colonnes recherche
    */
    String listeCrt[] =
    {
        "id",
        "compte",
        "libelle","departement","magasinLib"
    };

    String listeInt[] = null;

    /*
    colonnes affichées
    */
    String libEntete[] =
    {
        "id",
        "compte",
        "libelle","departementLib","magasinLib"
    };


    PageRecherche pr =
        new PageRecherche(lv,
                          request,
                          listeCrt,
                          listeInt,
                          3,
                          libEntete,
                          libEntete.length);                    

    pr.setUtilisateur((user.UserEJB) session.getValue("u"));

    pr.setLien((String) session.getValue("lien"));
    Liste[] liste = new Liste[2];
    TypeObjet liste0 = new TypeObjet();
    liste0.setNomTable("DEPARTEMENT");
    liste[0] = new Liste("departement",liste0,"val","id");
    TypeObjet liste1 = new TypeObjet();
    liste1.setNomTable("magasin2");
    liste[1] = new Liste("magasinLib",liste1,"val","val");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("departement").setLibelle("D&eacute;partement");
    pr.getFormu().getChamp("MagasinLib").setLibelle("Magasin");
    pr.getFormu().getChamp("compte").setLibelle("Emplacement");
    

    /*
    changer libellé champs recherche
    */
    pr.getFormu().getChamp("libelle").setLibelle("Libellé");


    pr.setApres("compta/localisation/localisation-liste.jsp");


    String[] colSomme = null;

    pr.creerObjetPage(libEntete, colSomme);


    /*
    bouton ajout localisation
    */
    pr.getFormu().setAnotherButton("" +

    "<a class=\"btn btn-primary pull-right btn-small\" " +

    "href=\"module.jsp?but=compta/localisation/localisation-saisie.jsp\">" +

    "<i class=\"material-symbols-rounded\">add</i>" +

    "Saisie d'une localisation</a>"

    );

%>


<div class="content-wrapper">

    <section class="content-header">

        <h1>Liste des localisations</h1>

    </section>



    <section class="content">


        <form action="<%=pr.getLien()%>?but=compta/localisation/localisation-liste.jsp"

              method="post"

              name="localisation"

              id="localisation">


            <%

                out.println(pr.getFormu().getHtmlEnsemble());

            %>


        </form>


        <div class="col-md-12 nopadding mb-5"></div>



        <%

            String lienTableau[] =
            {
                pr.getLien() +
                "?but=compta/localisation/localisation-fiche.jsp"
            };


            String colonneLien[] =
            {
                "id"
            };


            pr.getTableau().setLien(lienTableau);

            pr.getTableau().setColonneLien(colonneLien);

        %>



        <%

            String libEnteteAffiche[] =
            {
                "ID",
                "Emplacement",
                "Libellé" , "D&eacute;partement","Magasin"
            };


            pr.getTableau().setLibelleAffiche(libEnteteAffiche);


            out.println(pr.getTableau().getHtml());

            out.println(pr.getBasPage());

        %>


    </section>

</div>


<%

}
catch (Exception e)
{
    e.printStackTrace();
    throw e;
}

%>