<%@page import="utilitaire.Utilitaire"%>
<%@page import="java.io.File"%>
<%@page import="java.util.*"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="user.UserEJB" %>
<%@ page import="rapport.utilitaire.ConstanteCR" %>
<%
    UserEJB u = (UserEJB) request.getSession().getAttribute("u");
%>
<%!

    File chercherFichier(File dossier, String nom) {
        if (dossier == null || !dossier.isDirectory()) return null;
        File[] fichiers = dossier.listFiles();
        if (fichiers == null) return null;
        String nomLower = nom.toLowerCase();
        for (File f : fichiers) {
            if (f.getName().toLowerCase().contains(nomLower)) return f;
            if (f.isDirectory()) {
                File res = chercherFichier(f, nom);
                if (res != null) return res;
            }
        }
        return null;
    }

    void afficherArborescence(File dossier, int niveau, JspWriter out, String lienapres, String parent_dir, UserEJB u) throws java.io.IOException, Exception {
        if (dossier == null) return;

        String id = "node_" + Math.abs(dossier.hashCode()) + "_" + niveau;
        String href;
        if (parent_dir==null || parent_dir.isEmpty()) {
            href = dossier.getName().startsWith(ConstanteCR.PROJECT_NAME)
                    ? dossier.getName()
                    : "";
        } else {
            href = parent_dir + "/" + dossier.getName();
        }
        out.print("<div class='treeview-item' style='margin-left:" + (niveau * 20) + "px;'>");

        if (dossier.isDirectory()) {
            out.print("<span onclick=\"toggle('" + id + "', this)\" class='treeview-toggle'>");

            out.print("<i class='fa fa-caret-right'></i> ");

            out.print("</span>");
            out.print("<i class='fa fa-folder text-warning'></i> ");
            out.print("<span class='treeview-link'>" + dossier.getName() + "</span>");
            out.print("<div id='" + id + "' class='treeview-children' style='display:none;'>");

            File[] fichiers = dossier.listFiles();
            if (fichiers != null) {
                Arrays.sort(fichiers);
                for (File f : fichiers) {
                    afficherArborescence(f, niveau + 1, out, lienapres, href, u);
                }
            }

            out.print("</div>");
        } else {
            String rel = URLEncoder.encode(href.replace("\\","/"), "UTF-8");
            String url = "crfilemanager?path=" + rel;
            out.print("<i class='fa fa-file text-info'></i> ");
            out.print("<a class='treeview-link' href='javascript:downloadFile(\""+url+"\")'>"
                    + dossier.getName() + "</a>");
            if(dossier.getName().endsWith(".pdf")){
//                out.print("<button class='btn btn-info' style='margin-left:20px;'>Visualiser</button>");
                out.print("<a class='btn btn-info' style='margin-left:20px;' target='_blank' href='" + url + "&action=visioning'>Visualiser</a>");
            }
        }

        out.print("</div>");
    }
%>
<%
    String parent_dir = request.getParameter("parent");
    String searchName = request.getParameter("name");
    File parent = new File(ConstanteCR.BASE_DIR + (parent_dir == null || parent_dir.isEmpty()  ? "" : parent_dir));
    String apres = "rapport/ged/ged.jsp";
    String lien = (String)session.getAttribute("lien");
    String lienapres = lien + "?but=" + apres;
    if(parent.isDirectory()){
        String prevpath = filemanager.MyFileFilter.getPreviousPath(parent_dir);
%>
<div class="content-wrapper">
    <section class="content-header">
        <h1><i class="fa fa-folder-open"></i> <b style="margin-left: 15px;">Liste des fichiers</b></h1>
    </section>
    <section class="content">
        <div class="box box-primary">
            <div class="box-header with-border">
                <h3 class="box-title"><i class="fa fa-search"></i><b style="margin-left: 15px;">Recherche avanc&eacute;e</b></h3>
            </div>
            <form action="<%= lien %>" method="get" name="search" id="search" class="form-inline" style="padding:15px;">
                <input type="hidden" name="but" value="<%= apres %>" id="but">
                <div class="form-group">
                    <label for="name" class="sr-only">Nom</label>
                    <input name="name" type="text" class="form-control" id="name" placeholder="Nom du fichier ou dossier" value="<%= Utilitaire.champNull(searchName) %>" style="min-width:200px;">
                </div>
                <input type="hidden" id="sort" name="sort" value="<%= Utilitaire.champNull(request.getParameter("sort")) %>">
                <input type="hidden" id="parent" name="parent" value="<%= Utilitaire.champNull(parent_dir) %>">
                <button name="afficher" value="Afficher" type="submit" class="btn btn-warning" id="btnAfficher"><i class="fa fa-search"></i> Afficher</button>
                <% if(prevpath != null){ %>
                <a class="btn btn-default" href="<%= lienapres %>&parent=<%= prevpath %>" role="button" style="margin-left:10px;"><i class="fa fa-arrow-circle-left"></i> Précédent</a>
                <% } %>
            </form>
            <div class="box-body" style="background:#f9f9f9;">
                <div class="treeview" id="arborescence">
                    <%
                        if(searchName != null && !searchName.trim().isEmpty()) {
                            File cible = chercherFichier(parent, searchName.trim());
                            if(cible != null) {
                                afficherArborescence(cible, 0, out, lienapres, parent_dir, u);
                            } else {
                                out.print("<span style='color:red;'>Aucun fichier ou dossier trouvé.</span>");
                            }
                        } else {
                            afficherArborescence(parent, 0, out, lienapres, parent_dir, u);
                        }
                    %>
                </div>
            </div>
        </div>
    </section>
</div>
<style>
    .treeview { font-size: 16px; }
    .treeview-item { padding: 4px 0; transition: background 0.2s; border-radius: 3px;}
    .treeview-item:hover { background: #e6f2ff; }
    .treeview-link { color: #333; text-decoration: none; margin-left: 5px;}
    .treeview-link:hover { text-decoration: underline; }
    .treeview-toggle { color: #888; margin-right: 2px; cursor: pointer; }
    .treeview-children { margin-left: 10px; border-left: 1px dashed #ccc; padding-left: 10px;}
    @media (max-width: 600px) {
        .content-header h1 { font-size: 20px; }
        .form-inline .form-control { width: 100%; margin-bottom: 10px; }
        .form-inline .btn { width: 100%; }
    }
</style>
<script>
    function sort(order){
        $('#sort').val(order);
        $('#search').submit();
    }
    function toggle(id, el, dir) {
        var node = document.getElementById(id);
        if (node.style.display === "none") {
            node.style.display = "block";
            if(el) el.querySelector('i').className = 'fa fa-caret-down';
        } else {
            node.style.display = "none";
            if(el) el.querySelector('i').className = 'fa fa-caret-right';
        }
    }
</script>
<% } else { %>
<script>alert("Dossier invalide"); history.back(); </script>
<% } %>
<script>
    function downloadFile(url) {
        const a = document.createElement('a');
        a.href = url;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
    }
</script>