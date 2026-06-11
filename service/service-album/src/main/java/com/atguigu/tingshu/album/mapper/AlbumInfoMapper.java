package com.atguigu.tingshu.album.mapper;

import com.atguigu.tingshu.model.album.AlbumInfo;
import com.atguigu.tingshu.query.album.AlbumInfoQuery;
import com.atguigu.tingshu.vo.album.AlbumListVo;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface AlbumInfoMapper extends BaseMapper<AlbumInfo> {

	/**
	 * 分页查询用户专辑列表,关联 album_stat 聚合出四项统计数据
	 * (0401-播放量 0402-订阅量 0403-购买量 0404-评论数)
	 *
	 * @param pageInfo 分页对象,由分页插件拦截生成 limit 及 count 语句
	 * @param vo       查询条件:userId-用户id、albumTitle-标题模糊查询、status-审核状态
	 * @return 分页结果,记录类型为 AlbumListVo
	 */
	IPage<AlbumListVo> selectUserAlbumPage(IPage<AlbumListVo> pageInfo, @Param("vo") AlbumInfoQuery vo);
}
