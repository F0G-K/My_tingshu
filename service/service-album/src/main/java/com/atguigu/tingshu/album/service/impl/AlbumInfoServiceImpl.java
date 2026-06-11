package com.atguigu.tingshu.album.service.impl;

import com.atguigu.tingshu.album.mapper.AlbumAttributeValueMapper;
import com.atguigu.tingshu.album.mapper.AlbumInfoMapper;
import com.atguigu.tingshu.album.mapper.AlbumStatMapper;
import com.atguigu.tingshu.album.service.AlbumInfoService;
import com.atguigu.tingshu.common.constant.SystemConstant;
import com.atguigu.tingshu.common.execption.GuiguException;
import com.atguigu.tingshu.common.result.ResultCodeEnum;
import com.atguigu.tingshu.model.album.AlbumAttributeValue;
import com.atguigu.tingshu.model.album.AlbumInfo;
import com.atguigu.tingshu.model.album.AlbumStat;
import com.atguigu.tingshu.query.album.AlbumInfoQuery;
import com.atguigu.tingshu.vo.album.AlbumInfoVo;
import com.atguigu.tingshu.vo.album.AlbumListVo;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.util.List;

@Slf4j
@Service
@SuppressWarnings({"all"})
public class AlbumInfoServiceImpl extends ServiceImpl<AlbumInfoMapper, AlbumInfo> implements AlbumInfoService {

	@Autowired
	private AlbumInfoMapper albumInfoMapper;

	@Autowired
	private AlbumAttributeValueMapper albumAttributeValueMapper;

	@Autowired
	private AlbumStatMapper albumStatMapper;

	@Transactional(rollbackFor = Exception.class)
	@Override
	public void saveAlbumInfo(AlbumInfoVo albumInfoVo, Long userId) {
		//1.保存专辑基本信息
		AlbumInfo albumInfo = new AlbumInfo();
		BeanUtils.copyProperties(albumInfoVo, albumInfo);
		albumInfo.setUserId(userId);
		//审核状态:暂定默认审核通过
		albumInfo.setStatus(SystemConstant.ALBUM_STATUS_PASS);
		//付费专辑:前5集免费试听,每集试听30秒
		if (SystemConstant.ALBUM_PAY_TYPE_REQUIRE.equals(albumInfoVo.getPayType())) {
			albumInfo.setTracksForFree(5);
			albumInfo.setSecondsForFree(30);
		}
		albumInfoMapper.insert(albumInfo);
		Long albumId = albumInfo.getId();

		//2.保存专辑属性值列表
		if (!CollectionUtils.isEmpty(albumInfoVo.getAlbumAttributeValueVoList())) {
			albumInfoVo.getAlbumAttributeValueVoList().forEach(albumAttributeValueVo -> {
				AlbumAttributeValue albumAttributeValue = new AlbumAttributeValue();
				BeanUtils.copyProperties(albumAttributeValueVo, albumAttributeValue);
				albumAttributeValue.setAlbumId(albumId);
				albumAttributeValueMapper.insert(albumAttributeValue);
			});
		}

		//3.初始化专辑统计信息:播放量、订阅量、购买量、评论数
		this.saveAlbumStat(albumId, SystemConstant.ALBUM_STAT_PLAY);
		this.saveAlbumStat(albumId, SystemConstant.ALBUM_STAT_SUBSCRIBE);
		this.saveAlbumStat(albumId, SystemConstant.ALBUM_STAT_BUY);
		this.saveAlbumStat(albumId, SystemConstant.ALBUM_STAT_COMMENT);
	}

	@Override
	public IPage<AlbumListVo> findUserAlbumPage(IPage<AlbumListVo> pageInfo, AlbumInfoQuery albumInfoQuery) {
		return albumInfoMapper.selectUserAlbumPage(pageInfo, albumInfoQuery);
	}

	/**
	 * 初始化一条专辑统计记录,统计数目默认为0
	 *
	 * @param albumId  专辑id
	 * @param statType 统计类型:0401-播放量 0402-订阅量 0403-购买量 0404-评论数
	 */
	private void saveAlbumStat(Long albumId, String statType) {
		AlbumStat albumStat = new AlbumStat();
		albumStat.setAlbumId(albumId);
		albumStat.setStatType(statType);
		albumStat.setStatNum(0);
		albumStatMapper.insert(albumStat);
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public void removeAlbumInfo(Long id) {
		//1.删除专辑基本信息(@TableLogic自动转为逻辑删除)
		albumInfoMapper.deleteById(id);
		//2.删除专辑关联的属性值
		albumAttributeValueMapper.delete(
				new LambdaQueryWrapper<AlbumAttributeValue>().eq(AlbumAttributeValue::getAlbumId, id));
		//3.删除专辑关联的统计信息
		albumStatMapper.delete(
				new LambdaQueryWrapper<AlbumStat>().eq(AlbumStat::getAlbumId, id));
	}

	@Override
	public AlbumInfo getAlbumInfo(Long id) {
		//1.查询专辑基本信息
		AlbumInfo albumInfo = albumInfoMapper.selectById(id);
		if (albumInfo == null) {
			throw new GuiguException(ResultCodeEnum.DATA_ERROR);
		}
		//2.查询专辑属性值列表,封装到实体用于页面回显(不回显统计信息)
		List<AlbumAttributeValue> albumAttributeValueList = albumAttributeValueMapper.selectList(
				new LambdaQueryWrapper<AlbumAttributeValue>().eq(AlbumAttributeValue::getAlbumId, id));
		albumInfo.setAlbumAttributeValueVoList(albumAttributeValueList);
		return albumInfo;
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public void updateAlbumInfo(Long id, AlbumInfoVo albumInfoVo) {
		//1.更新专辑基本信息
		AlbumInfo albumInfo = new AlbumInfo();
		BeanUtils.copyProperties(albumInfoVo, albumInfo);
		albumInfo.setId(id);
		albumInfoMapper.updateById(albumInfo);

		//2.属性值先删后增:逻辑删除原有属性值
		albumAttributeValueMapper.delete(
				new LambdaQueryWrapper<AlbumAttributeValue>().eq(AlbumAttributeValue::getAlbumId, id));

		//3.保存页面提交的最新属性值列表
		if (!CollectionUtils.isEmpty(albumInfoVo.getAlbumAttributeValueVoList())) {
			albumInfoVo.getAlbumAttributeValueVoList().forEach(albumAttributeValueVo -> {
				AlbumAttributeValue albumAttributeValue = new AlbumAttributeValue();
				BeanUtils.copyProperties(albumAttributeValueVo, albumAttributeValue);
				albumAttributeValue.setAlbumId(id);
				albumAttributeValueMapper.insert(albumAttributeValue);
			});
		}
	}
}
