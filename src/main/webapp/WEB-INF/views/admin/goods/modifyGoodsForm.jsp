<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="euc-kr"
	isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<c:set var="goods"  value="${goodsMap.goods}"  />
<c:set var="imageFileList"  value="${goodsMap.imageFileList}"  />

<c:choose>
<c:when test='${not empty goods.goods_status}'>
<script>
window.onload=function()
{
	init();
}

function init(){
	var frm_mod_goods=document.frm_mod_goods;
	var h_goods_status=frm_mod_goods.h_goods_status;
	var goods_status=h_goods_status.value;
	var select_goods_status=frm_mod_goods.goods_status;
	 select_goods_status.value=goods_status;
}
</script>
</c:when>
</c:choose>
<script type="text/javascript">
// ������ ��ǰ ������ �Ӽ��� ���� ���� ��Ʈ�ѷ��� �����մϴ�.
function fn_modify_goods(goods_id, attribute){
	var frm_mod_goods=document.frm_mod_goods;
	var value="";
	if(attribute=='goods_sort'){
		value=frm_mod_goods.goods_sort.value;
	}else if(attribute=='goods_title'){
		value=frm_mod_goods.goods_title.value;  
	}else if(attribute=='goods_publisher'){
		value=frm_mod_goods.goods_publisher.value;
	}else if(attribute=='goods_price'){
		value=frm_mod_goods.goods_price.value;
	}else if(attribute=='goods_sales_price'){
		value=frm_mod_goods.goods_sales_price.value;
	}else if(attribute=='goods_point'){
		value=frm_mod_goods.goods_point.value;
	}else if(attribute=='goods_published_date'){
		value=frm_mod_goods.goods_published_date.value;
	}else if(attribute=='goods_delivery_price'){
		value=frm_mod_goods.goods_delivery_price.value;
	}else if(attribute=='goods_delivery_date'){
		value=frm_mod_goods.goods_delivery_date.value;
	}else if(attribute=='goods_status'){
		value=frm_mod_goods.goods_status.value;
	}else if(attribute=='goods_intro'){
		value=frm_mod_goods.goods_intro.value;
	}

	$.ajax({
		type : "post",
		async : false, //false�� ��� ��������� ó���Ѵ�.
		url : "${contextPath}/admin/goods/modifyGoodsInfo.do",
		data : {
			goods_id:goods_id,
			// ��ǰ �Ӽ��� ���� ���� Ajax�� �����մϴ�.
			attribute:attribute,
			value:value
		},
		success : function(data, textStatus) {
			if(data.trim()=='mod_success'){
				alert("��ǰ ������ �����߽��ϴ�.");
			}else if(data.trim()=='failed'){
				alert("�ٽ� �õ��� �ּ���.");	
			}
			
		},
		error : function(data, textStatus) {
			alert("������ �߻��߽��ϴ�."+data);
		},
		complete : function(data, textStatus) {
			//alert("�۾����Ϸ� �߽��ϴ�");
			
		}
	}); //end ajax	
}



  function readURL(input,preview) {
	//  alert(preview);
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            $('#'+preview).attr('src', e.target.result);
        }
        reader.readAsDataURL(input.files[0]);
    }
  }  

  // '�̹��� �߰�' Ŭ�� �� �� �̹��� ���� ���ε带 �߰��մϴ�.
  var cnt =1;
  function fn_addFile(){
	  $("#d_file").append("<br>"+"<input  type='file' name='detail_image"+cnt+"' id='detail_image"+cnt+"'  onchange=readURL(this,'previewImage"+cnt+"') />");
	  $("#d_file").append("<img  id='previewImage"+cnt+"'   width=200 height=200  />");
	  $("#d_file").append("<input  type='button' value='�߰�'  onClick=addNewImageFile('detail_image"+cnt+"','${imageFileList[0].goods_id}','detail_image')  />");
	  cnt++;
  }
  
  // ���� �̹����� �ٸ� �̹����� ������ �� FormData�� �̿��� Ajax�� �����մϴ�.
  function modifyImageFile(fileId,goods_id, image_id,fileType){
    // alert(fileId);
	  var form = $('#FILE_FORM')[0];
      var formData = new FormData(form);
      
      // formData�� ������ �̹����� �̹��� ������ name/value�� �����մϴ�.
      formData.append("fileName", $('#'+fileId)[0].files[0]);
      formData.append("goods_id", goods_id);
      formData.append("image_id", image_id);
      formData.append("fileType", fileType);
      
      $.ajax({
        url: '${contextPath}/admin/goods/modifyGoodsImageInfo.do',
        processData: false,
        contentType: false,
        // formData�� Ajax�� �����մϴ�.
        data: formData,
        type: 'POST',
	      success: function(result){
	         alert("�̹����� �����߽��ϴ�!");
	       }
      });
  }
  
  // �� �̹��� �߰� �� FormData�� �̿��� Ajax�� �����մϴ�.
  function addNewImageFile(fileId,goods_id, fileType){
	   //  alert(fileId);
		  var form = $('#FILE_FORM')[0];
	      var formData = new FormData(form);
	      formData.append("uploadFile", $('#'+fileId)[0].files[0]);
	      formData.append("goods_id", goods_id);
	      formData.append("fileType", fileType);
	      
	      $.ajax({
	          url: '${contextPath}/admin/goods/addNewGoodsImage.do',
	                  processData: false,
	                  contentType: false,
	                  data: formData,
	                  type: 'post',
	                  success: function(result){
	                      alert("�̹����� �����߽��ϴ�!");
	                  }
	          });
	  }
  
  // �̹����� �����մϴ�.
  function deleteImageFile(goods_id,image_id,imageFileName,trId){
	var tr = document.getElementById(trId);

      	$.ajax({
    		type : "post",
    		async : true, //false�� ��� ��������� ó���Ѵ�.
    		url : "${contextPath}/admin/goods/removeGoodsImage.do",
    		data: {goods_id:goods_id,
     	         image_id:image_id,
     	         imageFileName:imageFileName},
    		success : function(data, textStatus) {
    			alert("�̹����� �����߽��ϴ�.");
                tr.style.display = 'none';
    		},
    		error : function(data, textStatus) {
    			alert("������ �߻��߽��ϴ�."+textStatus);
    		},
    		complete : function(data, textStatus) {
    			//alert("�۾����Ϸ� �߽��ϴ�");
    			
    		}
    	}); //end ajax	
  }
  
  /* ��ǰ���� */
 function deleteGoods(goods_id) {
		  $.ajax({
		    type: "post",
		    async: true,
		    url: "${contextPath}/admin/goods/removeGoods.do",
		    data: { goods_id: goods_id },
		    success: function(data, textStatus) {
		      alert("��ǰ�� �����߽��ϴ�.");
		      location.href = "${contextPath}/admin/goods/adminGoodsMain.do";
		    },
		    error: function(data, textStatus) {
		      alert("������ �߻��߽��ϴ�." + textStatus);
		    },
		    complete: function(data, textStatus) {
		      //alert("�۾����Ϸ� �߽��ϴ�");
		    }
		  }); //end ajax
		}
  
  function backToList(obj) {
		obj.action = "${contextPath}/admin/goods/adminGoodsMain.do";
		obj.submit();
	}
  
</script>

</HEAD>
<BODY>

<div class="title_underline" style="margin-top: 50px">
			<h3><b>��ǰ ����</b></h3>
		</div>

<form  name="frm_mod_goods"  method=post >
<DIV class="clear"></DIV>
	<!-- ���� ��� ���� �� -->
	<DIV id="container">
		<UL class="tabs" id="goods_detail_menu">
			<li><A href="#tab1"><font color = "white">��ǰ����</font></A></li>
			<li><A href="#tab4"><font color = "white">��ǰ�Ұ�</font></A></li>
			<li><A href="#tab7"><font color = "white">��ǰ�̹���</font></A></li>
		</UL>
		<DIV class="tab_container">
			<DIV class="tab_content" id="tab1">
				<table class="table">
			<tr >
				<td width=200 >��ǰ�з�</td>
				<td width=500>
				  <select name="goods_sort">
					<c:choose>
				      <c:when test="${goods.goods_sort=='��' }">
						<option value="��" selected>�� </option>
				  	    <option value="����ũ">����ũ </option>
				  	    <option value="����Ʈ">����Ʈ </option>
				  	    <option value="��">�� </option>
				  	  </c:when>
				  	  <c:when test="${goods.goods_sort=='����ũ' }">
						<option value="��" >�� </option>
				  	    <option value="����ũ" selected>����ũ  </option>
				  	    <option value="����Ʈ">����Ʈ </option>
				  	    <option value="��">�� </option>
				  	  </c:when>
				  	  <c:when test="${goods.goods_sort=='����Ʈ' }">
						<option value="��" >�� </option>
				  	    <option value="����ũ" >����ũ  </option>
				  	    <option value="����Ʈ" selected>����Ʈ </option>
				  	    <option value="��">�� </option>
				  	  </c:when>
				  	   <c:when test="${goods.goods_sort=='��' }">
						<option value="��" >�� </option>
						<option value="����ũ" >����ũ </option>
				  	    <option value="����Ʈ" >����Ʈ </option>
				  	    <option value="��" selected>�� </option>
				  	  </c:when>
				  	</c:choose>
					</select>
				</td>
				<td >
				 <input  type="button" value="�����ݿ�" class="btn btn-secondary btn-sm" onClick="fn_modify_goods('${goods.goods_id }','goods_sort')"/>
				 
				</td>
			</tr>
			<tr >
				<td >��ǰ�̸�</td>
				<td><input name="goods_title" type="text" size="40"  value="${goods.goods_title }"/></td>
				<td>
				 <input  type="button" value="�����ݿ�" class="btn btn-secondary btn-sm" onClick="fn_modify_goods('${goods.goods_id }','goods_title')"/>
				</td>
			</tr>
			
			<tr>
				<td >��ǰȸ��</td>
				<td><input name="goods_publisher" type="text" size="40" value="${goods.goods_publisher }" /></td>
			     <td>
				  <input  type="button" value="�����ݿ�" class="btn btn-secondary btn-sm" onClick="fn_modify_goods('${goods.goods_id }','goods_publisher')"/>
				</td>
				
			</tr>
			<tr>
				<td >��ǰ����</td>
				<td><input name="goods_price" type="text" size="40" value="${goods.goods_price }" /></td>
				<td>
				 <input  type="button" value="�����ݿ�" class="btn btn-secondary btn-sm"onClick="fn_modify_goods('${goods.goods_id }','goods_price')"/>
				</td>
				
			</tr>
			
			<tr>
				<td >��ǰ�ǸŰ���</td>
				<td><input name="goods_sales_price" type="text" size="40" value="${goods.goods_sales_price }" /></td>
				<td>
				 <input  type="button" value="�����ݿ�" class="btn btn-secondary btn-sm" onClick="fn_modify_goods('${goods.goods_id }','goods_sales_price')"/>
				</td>
				
			</tr>
			
			
			<tr>
				<td >��ǰ ���� ����Ʈ</td>
				<td><input name="goods_point" type="text" size="40" value="${goods.goods_point }" /></td>
				<td>
				 <input  type="button" value="�����ݿ�" class="btn btn-secondary btn-sm" onClick="fn_modify_goods('${goods.goods_id }','goods_point')"/>
				</td>

			</tr>

			<tr>
				<td >��ǰ������</td>
				<td>
				  <input  name="goods_published_date"  type="date"  value="${goods.goods_published_date }" />
				</td>
				<td>
				 <input  type="button" value="�����ݿ�" class="btn btn-secondary btn-sm" onClick="fn_modify_goods('${goods.goods_id }','goods_published_date')"/>
				</td>

			</tr>
			
			<tr>
				<td >��ǰ ���� ������</td>
				<td>
				  <input name="goods_delivery_date" type="date"  value="${goods.goods_delivery_date }" />
				  </td>
				<td>
				 <input  type="button" value="�����ݿ�" class="btn btn-secondary btn-sm" onClick="fn_modify_goods('${goods.goods_id }','goods_delivery_date')"/>
				</td>

			</tr>
			
			<tr>
				<td >��ǰ����</td>
				<td>
				<select name="goods_status">
				  <option value="bestgoods"  >�α��ǰ</option>
				  <option value="newgoods" >�Ż�ǰ</option>
				  <option value="on_sale" selected >�Ǹ���</option>
				  <option value="buy_out" >ǰ��</option>
				 
				</select>
				<input  type="hidden" name="h_goods_status" value="${goods.goods_status }"/>
				</td>
				<td>
				 <input  type="button" value="�����ݿ�" class="btn btn-secondary btn-sm" onClick="fn_modify_goods('${goods.goods_id }','goods_status')"/>
				</td>
			</tr>
			<tr>
			 <td colspan=3>
			 	
			   <br>
			 </td>
			</tr>
				</table>	
				<c:forEach var="item" items="${imageFileList }"  varStatus="itemNum" begin="0" end="0">
				<input type="button" value="�����ϱ�" class="btn btn-secondary btn-sm" onClick="deleteGoods('${goods.goods_id}'), backToList(this.form)">
				</c:forEach>
			</DIV>
			<DIV class="tab_content" id="tab4">
				<P>
				<table class="table">
					<tr>
						<td>��ǰ�Ұ�</td>
						<td><textarea  rows="20" cols="80" name="goods_intro">
						${goods.goods_intro }
						</textarea>
						</td>
						<td>
						&nbsp;&nbsp;&nbsp;&nbsp;
						 <input type="button" value="�����ݿ�" onClick="fn_modify_goods('${goods.goods_id }','goods_intro')" class="btn btn-secondary btn-sm"/>
						</td>
					</tr>
			    </table>
				</P>
			</DIV>
			
			
			<DIV class="tab_content" id="tab7">
			   <form id="FILE_FORM" method="post" enctype="multipart/form-data"  >
				 <table class="table">
					 <tr>
					<c:forEach var="item" items="${imageFileList }"  varStatus="itemNum">
			        <c:choose>
			            <c:when test="${item.fileType=='main_image' }">
			              <tr>
						    <td>���� �̹���</td>
						    <td>
							  <input type="file"  id="main_image"  name="main_image"  onchange="readURL(this,'preview${itemNum.count}');" />
							  <input type="hidden"  name="image_id" value="${item.image_id}"  />
							<br>
						</td>
						<td>
						  <img  id="preview${itemNum.count }"   width=200 height=200 src="${contextPath}/download.do?goods_id=${item.goods_id}&fileName=${item.fileName}" />
						</td>
						<td>
						  &nbsp;&nbsp;&nbsp;&nbsp;
						</td>
						 <td>
						 <input  type="button" value="����" onClick="modifyImageFile('main_image','${item.goods_id}','${item.image_id}','${item.fileType}')" class="btn btn-secondary btn-sm"/>
						</td> 
					</tr>
					<tr>
					 <td>
					   <br>
					 </td>
					</tr>
			         </c:when>
			         <c:otherwise>
			           <tr  id="${itemNum.count-1}">
						<td>�� �̹���${itemNum.count-1 }</td>
						<td>
							<input type="file" name="detail_image"  id="detail_image"   onchange="readURL(this,'preview${itemNum.count}');" />
							<%-- <input type="text" id="image_id${itemNum.count }"  value="${item.fileName }" disabled  /> --%>
							<input type="hidden"  name="image_id" value="${item.image_id }"  />
							<br>
						</td>
						<td>
						  <img  id="preview${itemNum.count }"   width=200 height=200 src="${contextPath}/download.do?goods_id=${item.goods_id}&fileName=${item.fileName}">
						</td>
						<td>
						  &nbsp;&nbsp;&nbsp;&nbsp;
						</td>
						 <td>
						 <input  type="button" value="����"  onClick="modifyImageFile('detail_image','${item.goods_id}','${item.image_id}','${item.fileType}')" class="btn btn-secondary btn-sm"/>
						  <input  type="button" value="����"  onClick="deleteImageFile('${item.goods_id}','${item.image_id}','${item.fileName}','${itemNum.count-1}')" class="btn btn-secondary btn-sm"/>
						</td> 
					</tr>
					<tr>
					 <td>
					   <br>
					 </td>
					</tr> 
			         </c:otherwise>
			       </c:choose>		
			    </c:forEach>
			    <tr align="center">
			      <td colspan="3">
				      <div id="d_file">
				      </div>
			       </td>
			    </tr>
		   <tr>
		     <td align=center colspan=2>
		     
		     <input type="button" value="�̹��������߰��ϱ�"  onClick="fn_addFile()"  class="btn btn-secondary btn-sm"/>
		   </td>
		</tr> 
	</table>
	</form>
	</DIV>
	<DIV class="clear"></DIV>
					
</form>