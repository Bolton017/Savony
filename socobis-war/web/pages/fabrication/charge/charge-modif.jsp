<%@page import="charge.*"%>
<%@ page import="user.*"%>
<%@ page import="bean.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="affichage.*"%>

<%
    String autreparsley = "data-parsley-range='[8, 40]' required";
    Charge t = new Charge();
    
    
  
    PageUpdate pu = new PageUpdate(t, request, (user.UserEJB) session.getValue("u"));
    pu.setLien((String) session.getValue("lien"));
    String titre = "Charge";
    pu.setTitre("Modification de "+titre);

    Liste[] liste = null;
    
    
    liste = new Liste[1];
    TypeObjet point = new TypeObjet();
    point.setNomTable("typecharge");    
    liste[0] = new Liste("type", point, "val", "id");
    pu.getFormu().changerEnChamp(liste);
    titre = "Charge";
    pu.getFormu().getChamp("id").setAutre("readonly");
    pu.getFormu().getChamp("libelle").setLibelle("Libell&eacute;");
    pu.getFormu().getChamp("daty").setLibelle("D&eacute;scription");
    pu.getFormu().getChamp("pu").setLibelle("Prix");
    pu.getFormu().getChamp("qte").setLibelle("Quantit&eacute;");
    pu.getFormu().getChamp("type").setLibelle("Tye de charge");
    pu.getFormu().getChamp("idfabrication").setLibelle("Fabrication");
    pu.getFormu().getChamp("idingredients").setPageAppelComplete("produits.IngredientsLib", "id", "as_ingredients_lib","", "");
    pu.getFormu().getChamp("idIngredients").setLibelle("Ingr&eacute;dients");
    pu.getFormu().getChamp("idfabrication").setAutre("readonly");
    String idfabrication=pu.getFormu().getChamp("idfabrication").getValeur();
//    pu.getFormu().getChamp("etat").setVisible(false);
//    pu.getFormu().getChamp("id").setVisible(false);

    String lien = (String) session.getValue("lien");
    String id=pu.getBase().getTuppleID();
    pu.preparerDataFormu();

    
    String  mapping = "charge.Charge",
          nomtable = "Charge",
          apres = "fabrication/fabrication-fiche.jsp&id="+idfabrication+"&tab=inc/fabrication-charge";
 
%>
<style>
    .cardradius .cardradius {
        border: none;
        border-top: none !important;
    }
</style>
<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=fabrication/fabrication-fiche.jsp&tab=fabrication-charge&id="+id%>> <i class="fa fa-angle-left"></i></a><%=pu.getTitre()%></h1>
    <div class="row m-0">
        <div class="cardradius">
            <form action="<%= lien %>?but=apresTarif.jsp&id=<%out.print(request.getParameter("id"));%>" method="post">
                <%
                    out.println(pu.getFormu().getHtmlInsert());
                %>
                <div class="box-footer">
                    <button class="btn btn-primary pull-right" name="Submit2" type="submit">Valider</button>
                </div>
                <input name="acte" type="hidden" id="acte" value="update">
                <input name="bute" type="hidden" id="bute" value="<%=apres%>">
                <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
                <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
            </form>
        </div>
    </div>
</div>

 