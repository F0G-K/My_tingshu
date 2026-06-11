package com.atguigu.tingshu.album.api;

import com.atguigu.tingshu.album.service.AlbumInfoService;
import com.atguigu.tingshu.common.result.Result;
import com.atguigu.tingshu.common.util.AuthContextHolder;
import com.atguigu.tingshu.model.album.AlbumInfo;
import com.atguigu.tingshu.query.album.AlbumInfoQuery;
import com.atguigu.tingshu.vo.album.AlbumInfoVo;
import com.atguigu.tingshu.vo.album.AlbumListVo;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.simpleframework.xml.core.Validate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@Tag(name = "专辑管理")
@RestController
@RequestMapping("api/album")
@SuppressWarnings({"all"})
public class AlbumInfoApiController {

	@Autowired
	private AlbumInfoService albumInfoService;

	@Operation(summary = "保存专辑信息")
	@PostMapping("/albumInfo/saveAlbumInfo")
	public Result saveAlbumInfo(@RequestBody @Validated AlbumInfoVo albumInfoVo) {
		//1.获取当前用户id
		Long userId = AuthContextHolder.getUserId();
		//2.调用业务逻辑
		albumInfoService.saveAlbumInfo(albumInfoVo,userId);
		//3.返回结果
		return Result.ok();
	}
	/*
	* TODO 接口必须登录才能访问
	*  */
	@Operation(summary = "新增当前用户专辑分页列表(包含统计信息)")
	@PostMapping("/albumInfo/findUserAlbumPage/{page}/{limit}")
	public Result<IPage<AlbumListVo>> findUserAlbumPage(
			@PathVariable Long page,
			@PathVariable Long limit,
			@RequestBody AlbumInfoQuery query
			){
			//1.获取当前用户id
		Long userId = AuthContextHolder.getUserId();
		//2.创建分页对象,封装页码大小
		IPage<AlbumListVo> pageInfo = new Page<>(page , limit);
		//3.调用业务逻辑,最终执行持久层查询 封装分页集合,总记录数,总页数
		query.setUserId(userId);
		pageInfo = albumInfoService.findUserAlbumPage(pageInfo,query);
		//4.返回分页结果
		return Result.ok(pageInfo);
	}
	/**
	 * 根据专辑ID删除专辑
	 *
	 * @param id
	 * @return
	 */
	@Operation(summary = "根据专辑ID删除专辑")
	@DeleteMapping("/albumInfo/removeAlbumInfo/{id}")
	public Result removeAlbumInfo(@PathVariable Long id) {
		albumInfoService.removeAlbumInfo(id);
		return Result.ok();
	}

	/**
	 * 根据专辑ID查询专辑信息（包括专辑标签列表）
	 *
	 * @param id 专辑ID
	 * @return 专辑信息
	 */
	@Operation(summary = "根据专辑ID查询专辑信息（包括专辑标签列表）")
	@GetMapping("/albumInfo/getAlbumInfo/{id}")
	public Result<AlbumInfo> getAlbumInfo(@PathVariable Long id) {
		AlbumInfo albumInfo = albumInfoService.getAlbumInfo(id);
		return Result.ok(albumInfo);
	}
	/**
	 * 修改专辑信息
	 * @param id 专辑ID
	 * @param albumInfo 专辑修改后信息
	 * @return
	 */
	@Operation(summary = "更新专辑信息")
	@PutMapping("/albumInfo/updateAlbumInfo/{id}")
	public Result updateAlbumInfo(@PathVariable Long id, @Validated @RequestBody AlbumInfoVo albumInfoVo) {
		albumInfoService.updateAlbumInfo(id, albumInfoVo);
		return Result.ok();
	}
}

