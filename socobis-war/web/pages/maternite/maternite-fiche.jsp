<%@page import="paie.MaterniteLib"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
try{
    MaterniteLib mat = new MaterniteLib();
    PageConsulte pc = new PageConsulte(mat, request, u);
    pc.setTitre("Fiche d'un maternite");
    pc.getBase();
    MaterniteLib ma = (MaterniteLib)pc.getBase();
    String id = ma.getId();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idpersonnelLib").setLibelle("Personnel");
    pc.getChampByName("idfonctionlib").setLibelle("Fonction");
    pc.getChampByName("dateDepartTheorique").setLibelle("D&eacute;part th&eacute;orique");
    pc.getChampByName("dateDepartReel").setLibelle("D&eacute;part r&eacute;el");
    pc.getChampByName("dateAccouchement").setLibelle("Date d'accouchement");
    pc.getChampByName("dateRetourTheorique").setLibelle("Retour th&eacute;orique");
    pc.getChampByName("dateRetourAjuste").setLibelle("Retour ajust&eacute;");
    pc.getChampByName("dateFinAllaitement").setLibelle("date de fin d'allaitement");
     pc.getChampByName("dpa").setLibelle("Date pr&eacute;sum&eacute;e d'accouchement (DPA) ");
    pc.getChampByName("idPersonnel").setVisible(false);
    pc.getChampByName("idFonction").setVisible(false);
    String lienModif = "&acte=update";
    String pageDemandeCreche = "paie/employe/enfantpersonne-saisie.jsp";
    String lien = (String) session.getValue("lien");
    String pageModif = "maternite/maternite-saisie.jsp"+lienModif;
    String classe = "paie.Maternite";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=maternite/maternite-liste.jsp"%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                       <div class="box-footer">

                            <!-- Danger -->
<%--                            <a class="btn btn-danger pull-left btn-small"--%>
<%--                            href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=maternite/maternite-liste.jsp&classe="+classe %>">--%>
<%--                                Supprimer--%>
<%--                            </a>--%>

                            <!-- Ordre des boutons -->
                            <a class="btn btn-secondary pull-left btn-small"href="${pageContext.request.contextPath}/ExportPDF?action=imprimer_attestation_maternite&id=<%= request.getParameter("id")%>">Imprimer Attestation de maternite</a>
                            <!-- Crèche -->
                            <a class="btn btn-primary pull-right btn-small"
                            href="<%= lien + "?but="+ pageDemandeCreche +"&id=" + ma.getIdPersonnel() %>"
                            style="margin-right: 10px">
                                Crèche
                            </a>

                            <a class="btn btn-secondary pull-right btn-small"
                               href="<%= lien + "?but="+ pageModif +"&id=" + id+"&autres=departReel"%>"
                               style="margin-right: 10px">
                                Départ réel
                            </a>

                            <a class="btn btn-secondary pull-right btn-small"
                               href="<%= lien + "?but="+ pageModif +"&id=" + id+"&autres=departAjuste"%>"
                               style="margin-right: 10px">
                                Retour ajust&eacute;
                            </a>

<%--                            <a class="btn btn-secondary pull-right"--%>
<%--                               href="<%= lien + "?but="+ pageModif +"&id=" + id+"&autres=departFinAlignement"%>"--%>
<%--                               style="margin-right: 10px">--%>
<%--                                Fin allait.--%>
<%--                            </a>--%>

<%--                            <!-- Retour ajusté -->--%>
<%--                            <a class="btn btn-secondary pull-right btn-small"--%>
<%--                            href="<%= lien + "?but="+ pageModif +"&id=" + id+"&autres=departAjuste"%>"--%>
<%--                            style="margin-right: 10px">--%>
<%--                                Retour ajust&eacute;--%>
<%--                            </a>--%>

                            <!-- Date accouchement -->
                            <a class="btn btn-secondary pull-right btn-small"
                            href="<%= lien + "?but="+ pageModif +"&id=" + id+"&autres=departAccouchement"%>"
                            style="margin-right: 10px">
                                Date accouch.
                            </a>

                            <!-- Départ réel -->
<%--                            <a class="btn btn-secondary pull-right btn-small"--%>
<%--                            href="<%= lien + "?but="+ pageModif +"&id=" + id+"&autres=departReel"%>"--%>
<%--                            style="margin-right: 10px">--%>
<%--                                Départ réel--%>
<%--                            </a>--%>

                            <!-- Modifier -->
                            <a class="btn btn-secondary pull-right btn-small"
                            href="<%= lien + "?but="+ pageModif +"&id=" + id %>"
                            style="margin-right: 10px">
                                Modifier
                            </a>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>

