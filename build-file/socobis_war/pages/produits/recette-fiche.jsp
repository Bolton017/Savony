<

<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="mg.allosakafo.produits.RecetteLib"%>
<%
    RecetteLib a = new RecetteLib();
    a.setNomTable("AS_RECETTE_LIBCOMPLET");
    PageConsulte pc = pc = new PageConsulte(a, request, (user.UserEJB) session.getValue("u"));//ou avec argument liste Libelle si besoin
    UserEJB u=(user.UserEJB) session.getValue("u");
    pc.getChampByName("id").setLibelle("ID");
   pc.getChampByName("idproduits").setLibelle("ID Produit");
     pc.getChampByName("idingredients").setVisible(false);
     pc.getChampByName("idunite").setVisible(false);
      pc.getChampByName("unite").setVisible(false);
 
   pc.getChampByName("valunite").setLibelle("Unit&eacute;");
   
   pc.getChampByName("quantite").setLibelle("Quantit&eacute;s ");
  
    
   pc.getChampByName("libelleingredient").setLibelle("Ingredients");
     pc.getChampByName("libelleproduit").setLibelle("Nom Produit");
   pc.getChampByName("pu").setLibelle("Prix Unitaire ");
 

    pc.setTitre("Consultation Recette");


%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=produits/recette-liste.jsp"><i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                          <% if(u.getUser().getLoginuser().equalsIgnoreCase("narindra") || u.getUser().getLoginuser().equalsIgnoreCase("Baovola")){%>
						<a class="btn btn-warning pull-right"  href="<%=(String) session.getValue("lien") + "?but=produits/recette-modif.jsp&id=" + request.getParameter("id")%>" style="margin-right: 10px">Modifier</a>
                                           <!--     <a class="btn btn-danger pull-right"  href="<%=(String) session.getValue("lien") + "?but=apresTarif.jsp&id=" + request.getParameter("id")%>&acte=delete&bute=produits/recette-liste.jsp&classe=mg.allosakafo.produits.RecetteLib" style="margin-right: 10px">Supprimer</a> -->
                                  <% } %>                   
                                            
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%out.println(pc.getBasPage());%>
</div>