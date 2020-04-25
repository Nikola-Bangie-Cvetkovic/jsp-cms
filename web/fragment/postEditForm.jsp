<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="com.example.cms.database.entity.Tag" %>
<%@ page import="com.example.cms.database.dao.TagDAO" %>
<%@ page import="com.example.cms.database.dao.PostDAO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
    String idBlogPost = request.getParameter("idBlogPost");
    String title = request.getParameter("title");
    String slug = request.getParameter("slug");
    String excerpt = request.getParameter("excerpt");
    String body = request.getParameter("body");
    boolean published = Boolean.parseBoolean(request.getParameter("published"));
%>
<form action="${pageContext.request.contextPath}/admin/post/edit/<%=idBlogPost%>" method="POST" class="row">
    <br/>
    <div class="row">
        <div class="col s6 left-align">
            <button class="btn waves-light light-blue lighten-1" type="submit" name="action">
                Update<i class="material-icons right">publish</i>
            </button>
        </div>
    </div>
    <div class="row">
        <div class="col">
            <label class="">
                <input type="checkbox" class="filled-in" name="published" <%=published ? "checked" : ""%>/>
                <span>Published</span>
            </label>
        </div>
    </div>
    <div class="row">
        <div class="input-field col s12">
            <input id="idBlogPost" name="idBlogPost" type="text" hidden value="<%=idBlogPost%>">
            <label for="idBlogPost" hidden>Title</label>
        </div>
    </div>
    <div class="row">
        <div class="input-field col s12">
            <input id="title" name="title" type="text" data-length="128" value="<%=title%>">
            <label for="title">Title</label>
        </div>
    </div>
    <div class="row">
        <div class="input-field col s12">
            <input id="slug" name="slug" type="text" data-length="128" value="<%=slug%>">
            <label for="slug">ULR Slug</label>
        </div>
    </div>
    <div class="row">
        <div class="col s12">
            <label for="tags">Tags</label>
            <input id="tags" name="tags" type="hidden">
            <div class="chips chips-autocomplete">
            </div>
        </div>
    </div>
    <div class="row">
        <div class="input-field col s12">
            <textarea id="excerpt" class="materialize-textarea" name="excerpt"><%=excerpt%></textarea>
            <label for="excerpt">Preview Text</label>
        </div>
    </div>
    <input id="author" name="author" type="text" hidden value="<%=session.getAttribute("idUser")%>">
    <div class="row">
        <div class="input-field col s12">
            <textarea id="body" name="body" hidden class="materialize-textarea"><%=body%></textarea>
            <label for="body" hidden>Textarea</label>
        </div>
    </div>
</form>
<%
    TagDAO tagDAO = new TagDAO();
    PostDAO blogPostDAO = new PostDAO();
    List<Tag> tagList = tagDAO.findAll();
    request.setAttribute("tagList", tagList);
    Set<Tag> tags;
    try {
        tags = blogPostDAO.find(Long.parseLong(idBlogPost)).getTags();
    } catch (NumberFormatException ex) {
        tags = new HashSet<Tag>();
    }
    request.setAttribute("tags", tags);
%>
<script>
    let tags =
        <json:array items="${tagList}" var="tag">
        <json:object>
        <json:property name="idTag" value="${tag.idTag}"/>
        <json:property name="name" value="${tag.name}"/>
        </json:object>
        </json:array>;
    let currTags =
        <json:array items="${tags}" var="tag">
        <json:object>
        <json:property name="idTag" value="${tag.idTag}"/>
        <json:property name="name" value="${tag.name}"/>
        </json:object>
        </json:array>;
    document.addEventListener('DOMContentLoaded', function () {
        const tagsInput = document.querySelector('input[name="tags"]');

        // Update tags input element in page load
        tagsInput.value = currTags.map(t => ({tag: t.name})).map(t => t.tag).join(",");

        const instance = M.Chips.init(document.querySelector('.chips-autocomplete'), {
            data: currTags.map(t => ({tag: decodeURIComponent(t.name)})),
            autocompleteOptions: {
                data: tags.reduce((obj, item) => {
                    obj[decodeURIComponent(item.name)] = null;
                    return obj;
                }, {}),
            },
            onChipAdd: function () {
                tagsInput.value = this.chipsData.map(t => t.tag).join(",")

            },
            onChipDelete: function () {
                tagsInput.value = this.chipsData.map(t => t.tag).join(",")
            },
        });
    });
</script>
<c:if test="${!pageContext.request.getParameter('idBlogPost').equals('')}">
    <div class="col s6 right-align">
        <form method="post" action="${pageContext.request.contextPath}/admin/post/delete/<%=idBlogPost%>">
            <button class="btn waves-light red lighten-1" type="submit" name="action">
                Remove<i class="material-icons right">delete</i>
            </button>
        </form>
    </div>
</c:if>
