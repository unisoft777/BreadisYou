package com.bookshop01.board.qna.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.bookshop01.board.qna.dao.QnaDAO;
import com.bookshop01.board.qna.vo.QnaArticleVO;
import com.bookshop01.board.qna.vo.qnaImageVO;


@Service("qnaService")
@Transactional(propagation = Propagation.REQUIRED)
public class QnaServiceImpl  implements QnaService{
	@Autowired
	private QnaDAO qnaDAO;
	
	
	
	
	public Map listArticles(Map  pagingMap) throws Exception{
		Map articlesMap = new HashMap();
		List<QnaArticleVO> articlesList = qnaDAO.selectAllArticlesList(pagingMap);
		int totArticles = qnaDAO.selectTotArticles();
		articlesMap.put("articlesList", articlesList);
		articlesMap.put("totArticles", totArticles);
		//articlesMap.put("totArticles", 170);
        return articlesMap;
	}

	 //다중 이미지 추가하기
	@Override
	public int addNewArticle(Map articleMap) throws Exception{
		int articleNO = qnaDAO.insertNewArticle(articleMap);
		articleMap.put("articleNO", articleNO);
		qnaDAO.insertNewImage(articleMap);
		return articleNO;
	}
	
	//답글
	@Override
	public int addReplyArticle(Map articleMap) throws Exception{
		int articleNO = qnaDAO.insertReplyArticle(articleMap);
		articleMap.put("articleNO", articleNO);
		qnaDAO.insertNewImage(articleMap);
		return articleNO;
	}

	
	
	//다중 파일 보이기(여러 게시물을 기억하지는 못함) 게시글 번호 1개만 기억

//	public Map viewArticle(Map viewMap, HttpSession session) throws Exception {
//		Map articleMap = new HashMap();
//		
//		int articleNO = (Integer)viewMap.get("articleNO");
//		String id = (String) viewMap.get("id");
//		
//		//조회수를 갱신하기 전 먼저 글번호에 해당되는 글정보를 조회한 후, 로그인 아이디와 글쓴이 아이디를 비교한다.
//		ArticleVO articleVO = boardDAO.selectArticle(articleNO); 
//		String writerId = articleVO.getId();
//		System.out.println("글쓴이 아이디"+writerId);
//		
//	
//		if(id == null || !(id.equals(writerId))) { //로그인 아이디와 글쓴이 아이디가 같지 않으면 조회수를
//		 if( session.getAttribute("articleNO")==null || !session.getAttribute("articleNO").equals(articleNO)) {
//	            boardDAO.updateViewCounts(articleNO);
//	            articleVO = boardDAO.selectArticle(articleNO);
//	            
//	            // 현재 조회한 글번호를 세션에 저장
//	          session.setAttribute("articleNO", articleNO);
//	       }
//			
//		}
//		
//		List<ImageVO> imageFileList = boardDAO.selectImageFileList(articleNO);
//		articleMap.put("article", articleVO);
//		articleMap.put("imageFileList", imageFileList);
//		return articleMap;
//	}
	
	
	//다른 게시물을 클릭하고 다시 클릭해도 증가하지 않도록 수정 (여러개 게시물 세션에 저장)
	public Map viewArticle(Map viewMap, HttpSession session) throws Exception {
	    Map articleMap = new HashMap();
	    
	    int articleNO = (Integer)viewMap.get("articleNO");
	    String id = (String) viewMap.get("member_id");
	    
	    // 조회수를 갱신하기 전 먼저 글번호에 해당되는 글정보를 조회한 후, 로그인 아이디와 글쓴이 아이디를 비교한다.
	    QnaArticleVO articleVO = qnaDAO.selectArticle(articleNO); 
	    String writerId = articleVO.getMember_id();

	    if (id == null || !(id.equals(writerId))) { // 로그인 아이디와 글쓴이 아이디가 같지 않으면 조회수를
	        if (session.getAttribute("viewedArticles") == null) {
	            session.setAttribute("viewedArticles", new HashMap<Integer, Boolean>());
	        }
	        
	        //세션에서 값을 viewedArticles를 가져옴  23,44
	        Map<Integer, Boolean> viewedArticles = (Map<Integer, Boolean>) session.getAttribute("viewedArticles");
	      
	        if (!viewedArticles.containsKey(articleNO) || !viewedArticles.get(articleNO)) { // 28 
	        	qnaDAO.updateViewCounts(articleNO);
	            articleVO = qnaDAO.selectArticle(articleNO);
	            // 현재 조회한 글번호를 세션에 저장
	            viewedArticles.put(articleNO, true);//33
	            session.setAttribute("viewedArticles", viewedArticles); //23,44,33
	        }
	    }
	    
	    List<qnaImageVO> imageFileList = qnaDAO.selectImageFileList(articleNO);
	    articleMap.put("article", articleVO);
	    articleMap.put("imageFileList", imageFileList);
	    return articleMap;
	}
	

	@Override
	public void modArticle(Map articleMap) throws Exception {
		qnaDAO.updateArticle(articleMap);
		
		List<qnaImageVO> imageFileList = (List<qnaImageVO>)articleMap.get("imageFileList");
		List<qnaImageVO> modAddimageFileList = (List<qnaImageVO>)articleMap.get("modAddimageFileList");

		if(imageFileList != null && imageFileList.size() != 0) {
			int added_img_num = Integer.parseInt((String)articleMap.get("added_img_num"));
			int pre_img_num = Integer.parseInt((String)articleMap.get("pre_img_num"));

			if(pre_img_num < added_img_num) {  
				qnaDAO.updateImageFile(articleMap);     //기존 이미지도 수정하고 새 이미지도 추가한 경우  
				qnaDAO.insertModNewImage(articleMap);
			}else {
				qnaDAO.updateImageFile(articleMap);  //기존의 이미지를 수정만 한 경우
			}
		}else if(modAddimageFileList != null && modAddimageFileList.size() != 0) {  //새 이미지를 추가한 경우
			qnaDAO.insertModNewImage(articleMap);
		}
	}
	
	@Override
	public void removeArticle(int articleNO) throws Exception {
		qnaDAO.deleteArticle(articleNO);
	}


	@Override
	public void removeModImage(qnaImageVO imageVO) throws Exception {
		qnaDAO.deleteModImage(imageVO);
	}


}
