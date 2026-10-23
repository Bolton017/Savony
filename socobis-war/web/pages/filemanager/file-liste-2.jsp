<%--
  Created by IntelliJ IDEA.
  User: rabe
  Date: 10/09/2026
  Time: 11:15
--%>
<%@page pageEncoding="UTF-8"%>
<%@page import="filemanager.Util"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="java.util.List"%>
<%@page import="java.io.File"%>
<%
    String ctx = request.getContextPath();
    String lien = (String) session.getAttribute("lien");
    String apres = "filemanager/file-liste-2.jsp";
    String lienapres = lien + "?but=" + apres;

    String parent_dir = request.getParameter("parent");
    if (parent_dir == null) {
        parent_dir = "";
    }
    String nameFilter = request.getParameter("name");
    String col = request.getParameter("col");
    String dir = request.getParameter("dir");
    if (col == null || col.isEmpty()) {
        col = "name";
    }
    if (dir == null || dir.isEmpty()) {
        dir = "0";
    }

    File parent = Util.resolveSafe(parent_dir);
    if (parent != null && !parent.isFile()) {
        List<File> files = Util.list(parent, nameFilter, col, dir);

        String prevPath = "";
        if (!parent_dir.isEmpty()) {
            String[] p = parent_dir.split("/");
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < p.length - 1; i++) {
                if (!p[i].isEmpty()) {
                    sb.append("/").append(p[i]);
                }
            }
            prevPath = sb.toString();
        }
        boolean atRoot = parent_dir.isEmpty();

        String baseSort = lienapres + "&parent=" + Util.enc(parent_dir) + "&name=" + Util.enc(nameFilter == null ? "" : nameFilter);

        String[][] headers = {{"name", "Nom"}, {"size", "Taille"}, {"type", "Type"}, {"date", "Date de modification"}};
%>
<link rel="stylesheet" type="text/css" href="<%= ctx %>/plugins/font-awesome-4.4.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="<%= ctx %>/assets/css/ged.css">
<div class="content-wrapper" id="ged-index">
    <section class="content">
        <div class="box box-solid">
            <div class="box-header with-border">
                <div class="ged-toolbar">
                    <div class="ged-nav">
                        <% if (!atRoot) { %>
                        <a href="<%= lienapres %>&parent=<%= Util.enc(prevPath) %>" class="ged-back"><i class="fa fa-arrow-left"></i> Retour</a>
                        <% } %>
                        <span class="ged-path">
                            <a href="<%= lienapres %>&parent="><i class="fa fa-hdd-o"></i> async</a>
                            <%
                                String cumul = "";
                                if (!atRoot) {
                                    String[] segs = parent_dir.split("/");
                                    for (int i = 0; i < segs.length; i++) {
                                        if (segs[i].isEmpty()) {
                                            continue;
                                        }
                                        cumul += "/" + segs[i];
                                        if (i == segs.length - 1) {
                            %>
                            <span class="sep">/</span><span class="cur"><%= Utilitaire.escapeHtml(segs[i]) %></span>
                            <%          } else { %>
                            <span class="sep">/</span><a href="<%= lienapres %>&parent=<%= Util.enc(cumul) %>"><%= Utilitaire.escapeHtml(segs[i]) %></a>
                            <%          }
                                    }
                                }
                            %>
                        </span>
                    </div>
                    <div class="ged-search">
                        <input type="text" class="form-control input-sm" placeholder="Rechercher..."
                               value="<%= Utilitaire.escapeHtml(Utilitaire.champNull(nameFilter)) %>"
                               onkeydown="if(event.keyCode===13){event.preventDefault();window.location='<%= lienapres %>&parent=<%= Util.enc(parent_dir) %>&col=<%= Util.enc(col) %>&dir=<%= Util.enc(dir) %>&name='+encodeURIComponent(this.value);}">
                    </div>
                </div>
            </div>

            <div class="box-body">
                <table class="table table-hover ged-table">
                    <thead>
                        <tr>
                            <%
                                for (String[] h : headers) {
                                    String key = h[0];
                                    String lib = h[1];
                                    String cssCol = "c-" + key;
                                    if (key.equals("type")) {
                            %>
                            <th class="<%= cssCol %>"><%= lib %></th>
                            <%          } else {
                                    String nextDir = (key.equals(col) && !"1".equals(dir)) ? "1" : "0";
                                    String arrow = "";
                                    if (key.equals(col)) {
                                        arrow = "1".equals(dir) ? " <i class='fa fa-caret-down'></i>" : " <i class='fa fa-caret-up'></i>";
                                    }
                            %>
                            <th class="<%= cssCol %>"><a href="<%= baseSort %>&col=<%= key %>&dir=<%= nextDir %>"><%= lib %><%= arrow %></a></th>
                            <%      }
                                }
                            %>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (files.isEmpty()) { %>
                        <tr><td colspan="4" class="ged-empty">Aucun fichier</td></tr>
                        <% } else {
                            for (File f : files) {
                                String childPath = (parent_dir.isEmpty() ? "" : parent_dir) + "/" + f.getName();
                                if (f.isDirectory()) {
                        %>
                        <tr>
                            <td class="c-name"><i class="<%= Util.iconClass(f) %>"></i><a href="<%= lienapres %>&parent=<%= Util.enc(childPath) %>"><%= Utilitaire.escapeHtml(f.getName()) %></a></td>
                            <td class="c-size">&mdash;</td>
                            <td class="c-type"><%= Util.typeText(f) %></td>
                            <td class="c-date"><%= Util.dateModif(f) %></td>
                        </tr>
                        <%
                                } else {
                                    String fileUrl = ctx + "/FileManager2?parent=" + Util.enc(childPath);
                                    String previewUrl = fileUrl + "&inline=1";
                                    boolean previewable = Util.isPreviewable(f);
                                    String kind = Util.previewKind(f);
                        %>
                        <tr>
                            <td class="c-name">
                                <i class="<%= Util.iconClass(f) %>"></i>
                                <% if (previewable) { %>
                                <a href="javascript:;" data-url="<%= Utilitaire.escapeHtml(previewUrl) %>" data-dl="<%= Utilitaire.escapeHtml(fileUrl) %>"
                                   data-kind="<%= kind %>" data-name="<%= Utilitaire.escapeHtml(f.getName()) %>"
                                   onclick="openPreview(this.dataset.url, this.dataset.kind, this.dataset.name, this.dataset.dl)"><%= Utilitaire.escapeHtml(f.getName()) %></a>
                                <% } else { %>
                                <a href="<%= Utilitaire.escapeHtml(fileUrl) %>"><%= Utilitaire.escapeHtml(f.getName()) %></a>
                                <% } %>
                            </td>
                            <td class="c-size"><%= Util.humanSize(f.length()) %></td>
                            <td class="c-type"><%= Util.typeText(f) %></td>
                            <td class="c-date"><%= Util.dateModif(f) %></td>
                        </tr>
                        <%
                                }
                            }
                        } %>
                    </tbody>
                </table>
            </div>
        </div>
    </section>
</div>
<%
    } else {
%>
<script>
    alert("Dossier invalide");
    history.back();
</script>
<%
    }
%>
