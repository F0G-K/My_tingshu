package com.atguigu.tingshu.album.api;

import com.atguigu.tingshu.album.service.BaseCategoryService;
import com.atguigu.tingshu.common.result.Result;
import com.atguigu.tingshu.model.album.BaseAttribute;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Tag(name = "标签(属性)管理")
@RestController
@RequestMapping(value ="/api/album")
public class BaseAttributeApiController {
    @Autowired
    private BaseCategoryService baseCategoryService;

    @Operation(summary = "根据1级分类ID查询标签列表(包含标签取值)")
    @GetMapping("/category/findAttribute/{category1Id}")
    public Result<List<BaseAttribute>> findAttributeByCategory1Id(@PathVariable Long category1Id){
        List<BaseAttribute> list = baseCategoryService.findAttributeByCategory1Id(category1Id);
        return Result.ok(list);
    }

}
