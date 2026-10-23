
<%@page import="fichier.AttacherFichier"%>
<%@page import="uploadbean.UploadService"%>
<%@page import="lot.LotLib"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>

<%
    UserEJB u = (user.UserEJB) session.getValue("u");

%>
<%  
    try {
    LotLib objet = new LotLib();
    objet.setNomTable("lotlib");
    PageConsulte pc = new PageConsulte(objet, request, u);
    pc.setTitre("Fiche D'un Lot");
    pc.getBase();
    String id = pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("idEquipeLib").setLibelle("&Eacute;quipe");
    pc.getChampByName("idProduitLib").setLibelle("Produit");
    pc.getChampByName("idProduit").setVisible(false);
    pc.getChampByName("idEquipe").setVisible(false);
    String lien = (String) session.getValue("lien");
     String pageActuel = "vente/lot/lot-fiche.jsp";
     Onglet onglet = new Onglet("page1");
        onglet.setDossier("inc");
        Map<String, String> map = new HashMap<String, String>();
        map.put("vente-lot-liste", "");
        map.put("fabrication-lot-liste", "");
        
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "vente-lot-liste";
        }
        map.put(tab, "active");
        tab = "inc/" + tab + ".jsp";
        

%>

<div class="content-wrapper">
       <div class="row">
              <div class="col-md-3"></div>
              <div class="col-md-6">
                     <div class="box-fiche">
                            <div class="box">
                                   <div class="box-title with-border">
                                   </div>
                                   <div class="box-body">
                                          <%
                                              out.println(pc.getHtml());
                                          %>
                                          <br/>
                                   </div>
                            </div>
                           <div class="row m-0">
                                            <div class="col-md-12 nopadding">
                                                <div class="nav-tabs-custom">
                                                    <ul class="nav nav-tabs">
                                                        <!-- a modifier -->
                                                        <li class="<%=map.get("vente-lot-liste")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=vente-lot-liste">D&eacute;tail(s) ventes</a></li>
                                                        <li class="<%=map.get("fabrication-lot-liste")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=fabrication-lot-liste">Fabrication</a></li>
                                                        
                                                    </ul>
                                                    <div class="tab-content">       
                                                        <jsp:include page="<%= tab%>" >
                                                            <jsp:param name="idlot" value="<%= id%>" />
                                                        </jsp:include>
                                                    </div>
                                                </div>

                                            </div>
                                        </div>
                     </div>
              </div>
       </div>
</div>
                                                        <%
    } catch (Exception e) {
        e.printStackTrace();
    }%>



