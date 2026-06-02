package com.beletskiy.bash.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class VersionController {

    @GetMapping("/version")
    public Map<String, String> getVersion() {
        Map<String, String> response = new LinkedHashMap<>();
        response.put("version", "1.0.0");
        response.put("status", "active");
        return response;
    }
}

