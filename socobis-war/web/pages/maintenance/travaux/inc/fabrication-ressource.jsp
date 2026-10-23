
<%@page import="fabrication.*"%>
<%@page import="affichage.*"%>

<% try{
    RessourceParFabricationLib bc = new RessourceParFabricationLib();
    bc.setNomTable("RESSOURCEPARFABRICATIONCOMPLET");
    String lien = (String) session.getValue("lien");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "idFabrication","matricule","idPosteLib","etatlib"};
    String libEnteteAffiche[] =  {"ID", "Fabrication","Matricule","Poste","Etat"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("fabrication/fabrication-fiche.jsp&id="+request.getParameter("id")+"&tab=inc/fabrication-hs");
    String[] colSomme = null;

    if(request.getParameter("id") != null){
        pr.setAWhere(" and idFabrication='"+request.getParameter("id")+"'");
    }
    pr.setNpp(500);

    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=personnel/personnel-fiche.jsp",pr.getLien() + "?but=fabrication/heureSup-fiche.jsp"};
    String colonneLien[] = {"idPersonne","id"};
    String[] attributLien = {"id","id"};
    String colonneModal[] = {"idPersonne","id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setModalOnClick(true,colonneModal);
    pr.getTableau().setAfficheBouttondevalider(false);
    pr.getTableau().setNameBoutton("Valider");
%>
<% if(pr.getTableau().getHtmlWithCheckbox()!=null){ %>
<div class="box-body">
    <section class="">
        <a class="btn btn-success pull-left"  href="<%= lien + "?but=fabrication/ressource-modif-multiple.jsp&id=" + request.getParameter("id")%>" style="margin-right: 10px">Modifier</a>
        <form action="<%= pr.getLien() + "?but=apresMultiple.jsp"%>" method="post" >
            <input name="classe" type="hidden" id="classe" value="fabrication.RessourceParFabrication">
            <input name="nomtable" type="hidden" id="nomtable" value="RESSOURCEPARFABRICATION">
            <input name="acte" type="hidden" id="acte" value="validerMultiple">
            <input type="hidden" name="bute" value="<%= pr.getLien() + "?but=fabrication/fabrication-fiche.jsp&id="+request.getParameter("id")+"&tab=inc/fabrication-ressource" %>">
            <%
                out.println(pr.getTableau().getHtmlWithCheckbox());
            %>
        </form>
    </section>
</div>
<% }else{ %>
<h4>Aucune donn&eacute;e trouv&eacute;e</h4>
<% } %>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>








