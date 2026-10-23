<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="mg.cnaps.compta.*" %>

<%
try{

    LocalisationLib localisation = new LocalisationLib();

    /*
    champs affichés
    */
    String[] libelleLocalisationFiche =
    {
        "Id",
        "Emplacement",
        "Libell&eacute;"
    };

    PageConsulte pc =
        new PageConsulte(localisation,
                         request,
                         (user.UserEJB) session.getValue("u"));


    pc.getChampByName("typeCompte").setVisible(false);
    pc.getChampByName("Typecomptelib").setLibelle("Type Compte");
    pc.getChampByName("departement").setVisible(false);
    pc.getChampByName("magasinLib").setLibelle("Magasin");
    pc.getChampByName("departementLib").setLibelle("D&eacute;partement");

    pc.setLibAffichage(libelleLocalisationFiche);

    pc.setTitre("Fiche d'une localisation");

    pc.getChampByName("typeCompte").setVisible(false);
    pc.getChampByName("classy").setVisible(false);

    String lien = (String) session.getValue("lien");

%>

<div class="content-wrapper">

    <h1 class="box-title">

        <!-- bouton retour -->
        <a href="<%= lien + "?but=compta/localisation/localisation-liste.jsp" %>">
            <i class="fa fa-arrow-circle-left"></i>
        </a>

        <%= pc.getTitre() %>

    </h1>


    <div class="row m-0">

        <div class="col-md-6">

            <div class="box-fiche">

                <div class="box">

                    <div class="box-body">

                        <%= pc.getHtml() %>

                    </div>


                    <div class="box-footer">

                        <!-- bouton modifier -->
                        <a href="<%= lien +
                        "?but=compta/localisation/localisation-saisie.jsp&acte=update&id=" +
                        request.getParameter("id") %>"

                        class="btn btn-secondary pull-right">

                        Modifier

                        </a>


                        <!-- bouton supprimer -->
                        <a href="<%= lien +
                        "?but=apresTarif.jsp&acte=delete&classe=mg.cnaps.compta.Localisation&id=" +
                        request.getParameter("id") %>&bute=compta/localisation/localisation-liste.jsp"

                        class="btn btn-danger pull-right"
                        style="margin-right:10px;">

                        Supprimer

                        </a>


                    </div>

                </div>

            </div>

        </div>

    </div>

</div>

<%
}
catch (Exception e)
{
    e.printStackTrace();
}
%>