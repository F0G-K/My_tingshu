package com.atguigu.tingshu.album.service;

import com.atguigu.tingshu.model.album.AlbumInfo;
import com.atguigu.tingshu.query.album.AlbumInfoQuery;
import com.atguigu.tingshu.vo.album.AlbumInfoVo;
import com.atguigu.tingshu.vo.album.AlbumListVo;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;

public interface AlbumInfoService extends IService<AlbumInfo> {

	/**
	 * 保存专辑信息
	 * 1.保存专辑基本信息(album_info)
	 * 2.保存专辑属性值列表(album_attribute_value)
	 * 3.初始化专辑统计信息(album_stat:播放量、订阅量、购买量、评论数)
	 *
	 * @param albumInfoVo 页面提交的专辑信息
	 * @param userId      当前登录用户id
	 */
	void saveAlbumInfo(AlbumInfoVo albumInfoVo, Long userId);

	/**
	 * 分页查询当前用户的专辑列表(含播放量、订阅量、购买量、评论数统计)
	 *
	 * @param pageInfo       分页对象,已封装页码与每页条数
	 * @param albumInfoQuery 查询条件:userId-当前用户id(必传)、albumTitle-标题模糊查询、status-审核状态
	 * @return 分页结果,记录类型为 AlbumListVo(含总记录数、总页数)
	 */
	IPage<AlbumListVo> findUserAlbumPage(IPage<AlbumListVo> pageInfo, AlbumInfoQuery albumInfoQuery);

	/**
	 * 根据专辑ID删除专辑(逻辑删除,由MP的@TableLogic自动转为update is_deleted)
	 * 1.删除专辑基本信息(album_info)
	 * 2.删除专辑关联的属性值(album_attribute_value)
	 * 3.删除专辑关联的统计信息(album_stat)
	 *
	 * @param id 专辑id
	 */
	void removeAlbumInfo(Long id);

	/**
	 * 根据专辑ID查询专辑信息(用于修改页面回显)
	 * 1.查询专辑基本信息(album_info)
	 * 2.查询专辑属性值列表(album_attribute_value),封装到albumAttributeValueVoList
	 * 注意:不需要回显统计信息
	 *
	 * @param id 专辑id
	 * @return 专辑信息(含属性值集合);专辑不存在时抛出GuiguException
	 */
	AlbumInfo getAlbumInfo(Long id);

	/**
	 * 根据专辑ID更新专辑信息
	 * 1.更新专辑基本信息(album_info)
	 * 2.属性值采用先删后增:逻辑删除原有属性值,再保存页面提交的最新属性值列表
	 *
	 * @param id          专辑id
	 * @param albumInfoVo 页面提交的最新专辑信息
	 */
	void updateAlbumInfo(Long id, AlbumInfoVo albumInfoVo);
}
