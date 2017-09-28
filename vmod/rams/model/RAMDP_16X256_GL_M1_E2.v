// ================================================================
// NVDLA Open Source Project
// 
// Copyright(c) 2016 - 2017 NVIDIA Corporation.  Licensed under the
// NVDLA Open Hardware License; Check "LICENSE" which comes with 
// this distribution for more information.
// ================================================================

// File Name: RAMDP_16X256_GL_M1_E2.v

`timescale 10ps/1ps
`celldefine
module RAMDP_16X256_GL_M1_E2 (CLK_R, CLK_W, RE, WE
	, RADR_3, RADR_2, RADR_1, RADR_0
    , WADR_3, WADR_2, WADR_1, WADR_0
	, WD_255, WD_254, WD_253, WD_252, WD_251, WD_250, WD_249, WD_248, WD_247, WD_246, WD_245, WD_244, WD_243, WD_242, WD_241, WD_240, WD_239, WD_238, WD_237, WD_236, WD_235, WD_234, WD_233, WD_232, WD_231, WD_230, WD_229, WD_228, WD_227, WD_226, WD_225, WD_224, WD_223, WD_222, WD_221, WD_220, WD_219, WD_218, WD_217, WD_216, WD_215, WD_214, WD_213, WD_212, WD_211, WD_210, WD_209, WD_208, WD_207, WD_206, WD_205, WD_204, WD_203, WD_202, WD_201, WD_200, WD_199, WD_198, WD_197, WD_196, WD_195, WD_194, WD_193, WD_192, WD_191, WD_190, WD_189, WD_188, WD_187, WD_186, WD_185, WD_184, WD_183, WD_182, WD_181, WD_180, WD_179, WD_178, WD_177, WD_176, WD_175, WD_174, WD_173, WD_172, WD_171, WD_170, WD_169, WD_168, WD_167, WD_166, WD_165, WD_164, WD_163, WD_162, WD_161, WD_160, WD_159, WD_158, WD_157, WD_156, WD_155, WD_154, WD_153, WD_152, WD_151, WD_150, WD_149, WD_148, WD_147, WD_146, WD_145, WD_144, WD_143, WD_142, WD_141, WD_140, WD_139, WD_138, WD_137, WD_136, WD_135, WD_134, WD_133, WD_132, WD_131, WD_130, WD_129, WD_128, WD_127, WD_126, WD_125, WD_124, WD_123, WD_122, WD_121, WD_120, WD_119, WD_118, WD_117, WD_116, WD_115, WD_114, WD_113, WD_112, WD_111, WD_110, WD_109, WD_108, WD_107, WD_106, WD_105, WD_104, WD_103, WD_102, WD_101, WD_100, WD_99, WD_98, WD_97, WD_96, WD_95, WD_94, WD_93, WD_92, WD_91, WD_90, WD_89, WD_88, WD_87, WD_86, WD_85, WD_84, WD_83, WD_82, WD_81, WD_80, WD_79, WD_78, WD_77, WD_76, WD_75, WD_74, WD_73, WD_72, WD_71, WD_70, WD_69, WD_68, WD_67, WD_66, WD_65, WD_64, WD_63, WD_62, WD_61, WD_60, WD_59, WD_58, WD_57, WD_56, WD_55, WD_54, WD_53, WD_52, WD_51, WD_50, WD_49, WD_48, WD_47, WD_46, WD_45, WD_44, WD_43, WD_42, WD_41, WD_40, WD_39, WD_38, WD_37, WD_36, WD_35, WD_34, WD_33, WD_32, WD_31, WD_30, WD_29, WD_28, WD_27, WD_26, WD_25, WD_24, WD_23, WD_22, WD_21, WD_20, WD_19, WD_18, WD_17, WD_16, WD_15, WD_14, WD_13, WD_12, WD_11, WD_10, WD_9, WD_8, WD_7, WD_6, WD_5, WD_4, WD_3, WD_2, WD_1, WD_0
	, RD_255, RD_254, RD_253, RD_252, RD_251, RD_250, RD_249, RD_248, RD_247, RD_246, RD_245, RD_244, RD_243, RD_242, RD_241, RD_240, RD_239, RD_238, RD_237, RD_236, RD_235, RD_234, RD_233, RD_232, RD_231, RD_230, RD_229, RD_228, RD_227, RD_226, RD_225, RD_224, RD_223, RD_222, RD_221, RD_220, RD_219, RD_218, RD_217, RD_216, RD_215, RD_214, RD_213, RD_212, RD_211, RD_210, RD_209, RD_208, RD_207, RD_206, RD_205, RD_204, RD_203, RD_202, RD_201, RD_200, RD_199, RD_198, RD_197, RD_196, RD_195, RD_194, RD_193, RD_192, RD_191, RD_190, RD_189, RD_188, RD_187, RD_186, RD_185, RD_184, RD_183, RD_182, RD_181, RD_180, RD_179, RD_178, RD_177, RD_176, RD_175, RD_174, RD_173, RD_172, RD_171, RD_170, RD_169, RD_168, RD_167, RD_166, RD_165, RD_164, RD_163, RD_162, RD_161, RD_160, RD_159, RD_158, RD_157, RD_156, RD_155, RD_154, RD_153, RD_152, RD_151, RD_150, RD_149, RD_148, RD_147, RD_146, RD_145, RD_144, RD_143, RD_142, RD_141, RD_140, RD_139, RD_138, RD_137, RD_136, RD_135, RD_134, RD_133, RD_132, RD_131, RD_130, RD_129, RD_128, RD_127, RD_126, RD_125, RD_124, RD_123, RD_122, RD_121, RD_120, RD_119, RD_118, RD_117, RD_116, RD_115, RD_114, RD_113, RD_112, RD_111, RD_110, RD_109, RD_108, RD_107, RD_106, RD_105, RD_104, RD_103, RD_102, RD_101, RD_100, RD_99, RD_98, RD_97, RD_96, RD_95, RD_94, RD_93, RD_92, RD_91, RD_90, RD_89, RD_88, RD_87, RD_86, RD_85, RD_84, RD_83, RD_82, RD_81, RD_80, RD_79, RD_78, RD_77, RD_76, RD_75, RD_74, RD_73, RD_72, RD_71, RD_70, RD_69, RD_68, RD_67, RD_66, RD_65, RD_64, RD_63, RD_62, RD_61, RD_60, RD_59, RD_58, RD_57, RD_56, RD_55, RD_54, RD_53, RD_52, RD_51, RD_50, RD_49, RD_48, RD_47, RD_46, RD_45, RD_44, RD_43, RD_42, RD_41, RD_40, RD_39, RD_38, RD_37, RD_36, RD_35, RD_34, RD_33, RD_32, RD_31, RD_30, RD_29, RD_28, RD_27, RD_26, RD_25, RD_24, RD_23, RD_22, RD_21, RD_20, RD_19, RD_18, RD_17, RD_16, RD_15, RD_14, RD_13, RD_12, RD_11, RD_10, RD_9, RD_8, RD_7, RD_6, RD_5, RD_4, RD_3, RD_2, RD_1, RD_0
    
    , IDDQ
	, SVOP_1, SVOP_0
    , SLEEP_EN_7, SLEEP_EN_6, SLEEP_EN_5, SLEEP_EN_4, SLEEP_EN_3, SLEEP_EN_2, SLEEP_EN_1, SLEEP_EN_0, RET_EN
    
);

// nvProps NoBus SLEEP_EN_

`ifndef RAM_INTERFACE
`ifndef EMULATION
`ifndef SYNTHESIS
// Physical ram size defined as localparam
localparam phy_rows = 16;
localparam phy_cols = 256;
localparam phy_rcols_pos = 256'b0;
`endif //ndef SYNTHESIS
`endif //EMULATION
`endif //ndef RAM_INTERFACE

input CLK_R, CLK_W, RE, WE
	, RADR_3, RADR_2, RADR_1, RADR_0
    , WADR_3, WADR_2, WADR_1, WADR_0
	, WD_255, WD_254, WD_253, WD_252, WD_251, WD_250, WD_249, WD_248, WD_247, WD_246, WD_245, WD_244, WD_243, WD_242, WD_241, WD_240, WD_239, WD_238, WD_237, WD_236, WD_235, WD_234, WD_233, WD_232, WD_231, WD_230, WD_229, WD_228, WD_227, WD_226, WD_225, WD_224, WD_223, WD_222, WD_221, WD_220, WD_219, WD_218, WD_217, WD_216, WD_215, WD_214, WD_213, WD_212, WD_211, WD_210, WD_209, WD_208, WD_207, WD_206, WD_205, WD_204, WD_203, WD_202, WD_201, WD_200, WD_199, WD_198, WD_197, WD_196, WD_195, WD_194, WD_193, WD_192, WD_191, WD_190, WD_189, WD_188, WD_187, WD_186, WD_185, WD_184, WD_183, WD_182, WD_181, WD_180, WD_179, WD_178, WD_177, WD_176, WD_175, WD_174, WD_173, WD_172, WD_171, WD_170, WD_169, WD_168, WD_167, WD_166, WD_165, WD_164, WD_163, WD_162, WD_161, WD_160, WD_159, WD_158, WD_157, WD_156, WD_155, WD_154, WD_153, WD_152, WD_151, WD_150, WD_149, WD_148, WD_147, WD_146, WD_145, WD_144, WD_143, WD_142, WD_141, WD_140, WD_139, WD_138, WD_137, WD_136, WD_135, WD_134, WD_133, WD_132, WD_131, WD_130, WD_129, WD_128, WD_127, WD_126, WD_125, WD_124, WD_123, WD_122, WD_121, WD_120, WD_119, WD_118, WD_117, WD_116, WD_115, WD_114, WD_113, WD_112, WD_111, WD_110, WD_109, WD_108, WD_107, WD_106, WD_105, WD_104, WD_103, WD_102, WD_101, WD_100, WD_99, WD_98, WD_97, WD_96, WD_95, WD_94, WD_93, WD_92, WD_91, WD_90, WD_89, WD_88, WD_87, WD_86, WD_85, WD_84, WD_83, WD_82, WD_81, WD_80, WD_79, WD_78, WD_77, WD_76, WD_75, WD_74, WD_73, WD_72, WD_71, WD_70, WD_69, WD_68, WD_67, WD_66, WD_65, WD_64, WD_63, WD_62, WD_61, WD_60, WD_59, WD_58, WD_57, WD_56, WD_55, WD_54, WD_53, WD_52, WD_51, WD_50, WD_49, WD_48, WD_47, WD_46, WD_45, WD_44, WD_43, WD_42, WD_41, WD_40, WD_39, WD_38, WD_37, WD_36, WD_35, WD_34, WD_33, WD_32, WD_31, WD_30, WD_29, WD_28, WD_27, WD_26, WD_25, WD_24, WD_23, WD_22, WD_21, WD_20, WD_19, WD_18, WD_17, WD_16, WD_15, WD_14, WD_13, WD_12, WD_11, WD_10, WD_9, WD_8, WD_7, WD_6, WD_5, WD_4, WD_3, WD_2, WD_1, WD_0
    
    , SLEEP_EN_7, SLEEP_EN_6, SLEEP_EN_5, SLEEP_EN_4, SLEEP_EN_3, SLEEP_EN_2, SLEEP_EN_1, SLEEP_EN_0, RET_EN
    , IDDQ
    
	, SVOP_1, SVOP_0;
output RD_255, RD_254, RD_253, RD_252, RD_251, RD_250, RD_249, RD_248, RD_247, RD_246, RD_245, RD_244, RD_243, RD_242, RD_241, RD_240, RD_239, RD_238, RD_237, RD_236, RD_235, RD_234, RD_233, RD_232, RD_231, RD_230, RD_229, RD_228, RD_227, RD_226, RD_225, RD_224, RD_223, RD_222, RD_221, RD_220, RD_219, RD_218, RD_217, RD_216, RD_215, RD_214, RD_213, RD_212, RD_211, RD_210, RD_209, RD_208, RD_207, RD_206, RD_205, RD_204, RD_203, RD_202, RD_201, RD_200, RD_199, RD_198, RD_197, RD_196, RD_195, RD_194, RD_193, RD_192, RD_191, RD_190, RD_189, RD_188, RD_187, RD_186, RD_185, RD_184, RD_183, RD_182, RD_181, RD_180, RD_179, RD_178, RD_177, RD_176, RD_175, RD_174, RD_173, RD_172, RD_171, RD_170, RD_169, RD_168, RD_167, RD_166, RD_165, RD_164, RD_163, RD_162, RD_161, RD_160, RD_159, RD_158, RD_157, RD_156, RD_155, RD_154, RD_153, RD_152, RD_151, RD_150, RD_149, RD_148, RD_147, RD_146, RD_145, RD_144, RD_143, RD_142, RD_141, RD_140, RD_139, RD_138, RD_137, RD_136, RD_135, RD_134, RD_133, RD_132, RD_131, RD_130, RD_129, RD_128, RD_127, RD_126, RD_125, RD_124, RD_123, RD_122, RD_121, RD_120, RD_119, RD_118, RD_117, RD_116, RD_115, RD_114, RD_113, RD_112, RD_111, RD_110, RD_109, RD_108, RD_107, RD_106, RD_105, RD_104, RD_103, RD_102, RD_101, RD_100, RD_99, RD_98, RD_97, RD_96, RD_95, RD_94, RD_93, RD_92, RD_91, RD_90, RD_89, RD_88, RD_87, RD_86, RD_85, RD_84, RD_83, RD_82, RD_81, RD_80, RD_79, RD_78, RD_77, RD_76, RD_75, RD_74, RD_73, RD_72, RD_71, RD_70, RD_69, RD_68, RD_67, RD_66, RD_65, RD_64, RD_63, RD_62, RD_61, RD_60, RD_59, RD_58, RD_57, RD_56, RD_55, RD_54, RD_53, RD_52, RD_51, RD_50, RD_49, RD_48, RD_47, RD_46, RD_45, RD_44, RD_43, RD_42, RD_41, RD_40, RD_39, RD_38, RD_37, RD_36, RD_35, RD_34, RD_33, RD_32, RD_31, RD_30, RD_29, RD_28, RD_27, RD_26, RD_25, RD_24, RD_23, RD_22, RD_21, RD_20, RD_19, RD_18, RD_17, RD_16, RD_15, RD_14, RD_13, RD_12, RD_11, RD_10, RD_9, RD_8, RD_7, RD_6, RD_5, RD_4, RD_3, RD_2, RD_1, RD_0;

	
`ifndef RAM_INTERFACE
	//assemble & rename wires
	wire [3:0] RA = {RADR_3, RADR_2, RADR_1, RADR_0};
	wire [3:0] WA = {WADR_3, WADR_2, WADR_1, WADR_0};
	wire [255:0] WD = {WD_255, WD_254, WD_253, WD_252, WD_251, WD_250, WD_249, WD_248, WD_247, WD_246, WD_245, WD_244, WD_243, WD_242, WD_241, WD_240, WD_239, WD_238, WD_237, WD_236, WD_235, WD_234, WD_233, WD_232, WD_231, WD_230, WD_229, WD_228, WD_227, WD_226, WD_225, WD_224, WD_223, WD_222, WD_221, WD_220, WD_219, WD_218, WD_217, WD_216, WD_215, WD_214, WD_213, WD_212, WD_211, WD_210, WD_209, WD_208, WD_207, WD_206, WD_205, WD_204, WD_203, WD_202, WD_201, WD_200, WD_199, WD_198, WD_197, WD_196, WD_195, WD_194, WD_193, WD_192, WD_191, WD_190, WD_189, WD_188, WD_187, WD_186, WD_185, WD_184, WD_183, WD_182, WD_181, WD_180, WD_179, WD_178, WD_177, WD_176, WD_175, WD_174, WD_173, WD_172, WD_171, WD_170, WD_169, WD_168, WD_167, WD_166, WD_165, WD_164, WD_163, WD_162, WD_161, WD_160, WD_159, WD_158, WD_157, WD_156, WD_155, WD_154, WD_153, WD_152, WD_151, WD_150, WD_149, WD_148, WD_147, WD_146, WD_145, WD_144, WD_143, WD_142, WD_141, WD_140, WD_139, WD_138, WD_137, WD_136, WD_135, WD_134, WD_133, WD_132, WD_131, WD_130, WD_129, WD_128, WD_127, WD_126, WD_125, WD_124, WD_123, WD_122, WD_121, WD_120, WD_119, WD_118, WD_117, WD_116, WD_115, WD_114, WD_113, WD_112, WD_111, WD_110, WD_109, WD_108, WD_107, WD_106, WD_105, WD_104, WD_103, WD_102, WD_101, WD_100, WD_99, WD_98, WD_97, WD_96, WD_95, WD_94, WD_93, WD_92, WD_91, WD_90, WD_89, WD_88, WD_87, WD_86, WD_85, WD_84, WD_83, WD_82, WD_81, WD_80, WD_79, WD_78, WD_77, WD_76, WD_75, WD_74, WD_73, WD_72, WD_71, WD_70, WD_69, WD_68, WD_67, WD_66, WD_65, WD_64, WD_63, WD_62, WD_61, WD_60, WD_59, WD_58, WD_57, WD_56, WD_55, WD_54, WD_53, WD_52, WD_51, WD_50, WD_49, WD_48, WD_47, WD_46, WD_45, WD_44, WD_43, WD_42, WD_41, WD_40, WD_39, WD_38, WD_37, WD_36, WD_35, WD_34, WD_33, WD_32, WD_31, WD_30, WD_29, WD_28, WD_27, WD_26, WD_25, WD_24, WD_23, WD_22, WD_21, WD_20, WD_19, WD_18, WD_17, WD_16, WD_15, WD_14, WD_13, WD_12, WD_11, WD_10, WD_9, WD_8, WD_7, WD_6, WD_5, WD_4, WD_3, WD_2, WD_1, WD_0};

	wire [255:0] RD;
	assign {RD_255, RD_254, RD_253, RD_252, RD_251, RD_250, RD_249, RD_248, RD_247, RD_246, RD_245, RD_244, RD_243, RD_242, RD_241, RD_240, RD_239, RD_238, RD_237, RD_236, RD_235, RD_234, RD_233, RD_232, RD_231, RD_230, RD_229, RD_228, RD_227, RD_226, RD_225, RD_224, RD_223, RD_222, RD_221, RD_220, RD_219, RD_218, RD_217, RD_216, RD_215, RD_214, RD_213, RD_212, RD_211, RD_210, RD_209, RD_208, RD_207, RD_206, RD_205, RD_204, RD_203, RD_202, RD_201, RD_200, RD_199, RD_198, RD_197, RD_196, RD_195, RD_194, RD_193, RD_192, RD_191, RD_190, RD_189, RD_188, RD_187, RD_186, RD_185, RD_184, RD_183, RD_182, RD_181, RD_180, RD_179, RD_178, RD_177, RD_176, RD_175, RD_174, RD_173, RD_172, RD_171, RD_170, RD_169, RD_168, RD_167, RD_166, RD_165, RD_164, RD_163, RD_162, RD_161, RD_160, RD_159, RD_158, RD_157, RD_156, RD_155, RD_154, RD_153, RD_152, RD_151, RD_150, RD_149, RD_148, RD_147, RD_146, RD_145, RD_144, RD_143, RD_142, RD_141, RD_140, RD_139, RD_138, RD_137, RD_136, RD_135, RD_134, RD_133, RD_132, RD_131, RD_130, RD_129, RD_128, RD_127, RD_126, RD_125, RD_124, RD_123, RD_122, RD_121, RD_120, RD_119, RD_118, RD_117, RD_116, RD_115, RD_114, RD_113, RD_112, RD_111, RD_110, RD_109, RD_108, RD_107, RD_106, RD_105, RD_104, RD_103, RD_102, RD_101, RD_100, RD_99, RD_98, RD_97, RD_96, RD_95, RD_94, RD_93, RD_92, RD_91, RD_90, RD_89, RD_88, RD_87, RD_86, RD_85, RD_84, RD_83, RD_82, RD_81, RD_80, RD_79, RD_78, RD_77, RD_76, RD_75, RD_74, RD_73, RD_72, RD_71, RD_70, RD_69, RD_68, RD_67, RD_66, RD_65, RD_64, RD_63, RD_62, RD_61, RD_60, RD_59, RD_58, RD_57, RD_56, RD_55, RD_54, RD_53, RD_52, RD_51, RD_50, RD_49, RD_48, RD_47, RD_46, RD_45, RD_44, RD_43, RD_42, RD_41, RD_40, RD_39, RD_38, RD_37, RD_36, RD_35, RD_34, RD_33, RD_32, RD_31, RD_30, RD_29, RD_28, RD_27, RD_26, RD_25, RD_24, RD_23, RD_22, RD_21, RD_20, RD_19, RD_18, RD_17, RD_16, RD_15, RD_14, RD_13, RD_12, RD_11, RD_10, RD_9, RD_8, RD_7, RD_6, RD_5, RD_4, RD_3, RD_2, RD_1, RD_0} = RD;
	wire [1:0] SVOP = {SVOP_1, SVOP_0};
    wire [7:0] SLEEP_EN = {SLEEP_EN_7, SLEEP_EN_6, SLEEP_EN_5, SLEEP_EN_4, SLEEP_EN_3, SLEEP_EN_2, SLEEP_EN_1, SLEEP_EN_0};
    

`ifndef EMULATION
`ifndef SYNTHESIS

    //State point clobering signals:
    wire check_x = (SVOP_0 ^ SVOP_1);
    wire clobber_x;
    assign clobber_x = ((check_x === 1'bx) || (check_x === 1'bz)) ? 1'b1 : 1'b0;
    wire clobber_array = ((|SLEEP_EN) & ~RET_EN) | clobber_x;
    wire clobber_flops = (|SLEEP_EN) | clobber_x;
    integer i;
    always  @(clobber_array) begin
      if (clobber_array) begin
    		for (i=0; i<16; i=i+1) begin
    		    ITOP.io.array[i] <= 256'bx;
    		end
      end
    end

//VCS coverage off     
    always  @(clobber_flops) begin
        if (clobber_flops) begin
        ITOP.we_lat <= 1'bx;
        ITOP.wa_lat <= 4'bx;
        ITOP.wd_lat <= 256'bx;
        
        ITOP.re_lat <= 1'bx;
        ITOP.ra_lat <= 4'bx;
        ITOP.io.r0_dout_tmp <= 256'b0;
        end
    end
//VCS coverage on    

//VCS coverage off
`ifdef NV_RAM_ASSERT
    //first reset signal for nv_assert_module:
    reg sim_reset;                                                     
    initial begin: init_sim_reset
        sim_reset = 0;  
        #6 sim_reset = 1;
    end

    reg rst_clk;                                                     
    initial begin: init_rst_clk
        rst_clk = 0; 
        #2 rst_clk = 1; 
        #4 rst_clk = 0;  
    end

    //internal weclk|reclk gating signal:
    wire weclk_gating = ITOP.we_lat & ~IDDQ;
    wire reclk_gating = ITOP.re_lat & ~IDDQ;

  //Assertion checks for power sequence of G-option RAMDP:

    //weclk_gating after 2 clk
    reg weclk_gating_1p, weclk_gating_2p;
    always @(posedge CLK_W) begin
        weclk_gating_1p <= weclk_gating;
        weclk_gating_2p <= weclk_gating_1p;
    end

    //reclk_gating after 2 clk
    reg reclk_gating_1p, reclk_gating_2p;
    always @(posedge CLK_R) begin
        reclk_gating_1p <= reclk_gating;
        reclk_gating_2p <= reclk_gating_1p;
    end
    
    //RET_EN off after 2 CLK_W
    reg ret_en_w_1p, ret_en_w_2p;
    always @(posedge CLK_W or posedge RET_EN) begin
        if(RET_EN) 
            begin
                ret_en_w_1p <= 1'b1;
                ret_en_w_2p <= 1'b1;
            end
        else
            begin
                ret_en_w_1p <= RET_EN;
                ret_en_w_2p <= ret_en_w_1p;
            end
    end

    //RET_EN off after 2 CLK_R
    reg ret_en_r_1p, ret_en_r_2p;
    always @(posedge CLK_R or posedge RET_EN) begin
        if(RET_EN) 
            begin
                ret_en_r_1p <= 1'b1;
                ret_en_r_2p <= 1'b1;
            end
        else
            begin
                ret_en_r_1p <= RET_EN;
                ret_en_r_2p <= ret_en_r_1p;
            end
    end

    wire sleep_en_or = (|SLEEP_EN) ;
    //SLEEP_EN off after 2 CLK_W
    reg sleep_en_off_w_1p, sleep_en_off_w_2p;
    always @(posedge CLK_W or posedge sleep_en_or) begin
        if(sleep_en_or)
            begin
                sleep_en_off_w_1p <= 1'b1;
                sleep_en_off_w_2p <= 1'b1;
            end
        else
            begin
                sleep_en_off_w_1p <= sleep_en_or;
                sleep_en_off_w_2p <= sleep_en_off_w_1p;
            end            
    end

    //SLEEP_EN off after 2 CLK_R
    reg sleep_en_off_r_1p, sleep_en_off_r_2p;
    always @(posedge CLK_R or posedge sleep_en_or) begin
        if(sleep_en_or)
            begin
                sleep_en_off_r_1p <= 1'b1;
                sleep_en_off_r_2p <= 1'b1;
            end
        else
            begin
                sleep_en_off_r_1p <= |sleep_en_or;
                sleep_en_off_r_2p <= sleep_en_off_r_1p;
            end            
    end    


  //#1 From function mode to retention mode:
    
    //Power-S1.1:illegal assert RET_EN after asserting SLEEP_EN 
    wire disable_power_assertion_S1P1 = $test$plusargs("disable_power_assertions_globally") | $test$plusargs("disable_power_assertion_assert_RET_EN_after_SLEEP_EN_on_when_function2retention");
    nv_assert_never #(0,0, "Power-S1.1:illegal assert RET_EN after asserting SLEEP_EN") inst_S1P1 (RET_EN ^ rst_clk, ~disable_power_assertion_S1P1 & sim_reset, (|SLEEP_EN));

    //Power-S1.2:illegal assert RET_EN without 2 nop-CLK
    wire disable_power_assertion_S1P2 = $test$plusargs("disable_power_assertions_globally") | $test$plusargs("disable_power_assertion_assert_RET_EN_without_2_nop_CLK");
    nv_assert_never #(0,0, "Power-S1.2:illegal assert RET_EN without 2 nop-CLK") inst_S1P2 (RET_EN ^ rst_clk, ~disable_power_assertion_S1P2 & sim_reset, weclk_gating | weclk_gating_1p | weclk_gating_2p | reclk_gating | reclk_gating_1p | reclk_gating_2p);

  //#2 From retention mode to function mode:

    //Power-S2.1:illegal write without 2 nop-CLK after de-asserting RET_EN
    wire disable_power_assertion_S2P1 = $test$plusargs("disable_power_assertions_globally") | $test$plusargs("disable_power_assertion_write_without_2_nop_CLK_after_retention2function");
    nv_assert_never #(0,0, "Power-S2.1:illegal write without 2 nop-CLK after de-asserting RET_EN") inst_S2P1 (CLK_W ^ rst_clk, ~disable_power_assertion_S2P1 & sim_reset, ~RET_EN & ret_en_w_2p & weclk_gating);

    //Power-S2.2:illegal read without 2 nop-CLK after de-asserting RET_EN
    wire disable_power_assertion_S2P2 = $test$plusargs("disable_power_assertions_globally") | $test$plusargs("disable_power_assertion_read_without_2_nop_CLK_after_retention2function");
    nv_assert_never #(0,0, "Power-S2.2:illegal read without 2 nop-CLK after de-asserting RET_EN") inst_S2P2 (CLK_R ^ rst_clk, ~disable_power_assertion_S2P2 & sim_reset, ~RET_EN & ret_en_r_2p & reclk_gating);

  //#3 From function mode to sleep mode:

    //Power-S3.2:illegal assert SLEEP_EN without 2 nop-CLK
    wire disable_power_assertion_S3P2 = $test$plusargs("disable_power_assertions_globally") | $test$plusargs("disable_power_assertion_assert_SLEEP_EN_without_2_nop_CLK");
    nv_assert_never #(0,0, "Power-S3.2:illegal assert SLEEP_EN without 2 nop-CLK") inst_S3P2 ((|SLEEP_EN) ^ rst_clk, ~disable_power_assertion_S3P2 & sim_reset, weclk_gating | weclk_gating_1p | weclk_gating_2p | reclk_gating | reclk_gating_1p | reclk_gating_2p);

  //#4 From sleep mode to function mode:

    //Power-S4.1:illegal write without 2 nop-CLK after switching from sleep mode to function mode
    wire disable_power_assertion_S4P1 = $test$plusargs("disable_power_assertions_globally") | $test$plusargs("disable_power_assertion_write_without_2_nop_CLK_after_sleep2function");
    nv_assert_never #(0,0, "Power-S4.1:illegal write without 2 nop-CLK after switching from sleep mode to function mode") inst_S4P1 (CLK_W ^ rst_clk, ~disable_power_assertion_S4P1 & sim_reset, ~(|SLEEP_EN) & sleep_en_off_w_2p & weclk_gating);
   
    //Power-S4.2:illegal read without 2 nop-CLK after switching from sleep mode to function mode
    wire disable_power_assertion_S4P2 = $test$plusargs("disable_power_assertions_globally") | $test$plusargs("disable_power_assertion_read_without_2_nop_after_sleep2function");
    nv_assert_never #(0,0, "Power-S4.2:illegal read without 2 nop-CLK after switching from sleep mode to function mode") inst_S4P2 (CLK_R ^ rst_clk, ~disable_power_assertion_S4P2 & sim_reset, ~(|SLEEP_EN) & sleep_en_off_r_2p & reclk_gating);
`endif //NV_RAM_ASSERT
//VCS coverage on 

`ifdef NV_RAM_EXPAND_ARRAY
  wire [256-1:0] Q_15 = ITOP.io.array[15];
  wire [256-1:0] Q_14 = ITOP.io.array[14];
  wire [256-1:0] Q_13 = ITOP.io.array[13];
  wire [256-1:0] Q_12 = ITOP.io.array[12];
  wire [256-1:0] Q_11 = ITOP.io.array[11];
  wire [256-1:0] Q_10 = ITOP.io.array[10];
  wire [256-1:0] Q_9 = ITOP.io.array[9];
  wire [256-1:0] Q_8 = ITOP.io.array[8];
  wire [256-1:0] Q_7 = ITOP.io.array[7];
  wire [256-1:0] Q_6 = ITOP.io.array[6];
  wire [256-1:0] Q_5 = ITOP.io.array[5];
  wire [256-1:0] Q_4 = ITOP.io.array[4];
  wire [256-1:0] Q_3 = ITOP.io.array[3];
  wire [256-1:0] Q_2 = ITOP.io.array[2];
  wire [256-1:0] Q_1 = ITOP.io.array[1];
  wire [256-1:0] Q_0 = ITOP.io.array[0];

`endif //def NV_RAM_EXPAND_ARRAY

//VCS coverage off
`ifdef MONITOR
task monitor_on;
    begin
        ITOP.io.monitor_on = 1'b1;
    end
endtask

task monitor_off;
    begin
        ITOP.io.monitor_on = 1'b0;
        ITOP.io.dump_monitor_result = 1'b1;
    end
endtask
`endif//def MONITOR
//VCS coverage on

//VCS coverage off
task mem_fill_value;
input fill_bit;
integer i;
begin
    for (i=0; i<16; i=i+1) begin
    	ITOP.io.array[i] = {256{fill_bit}};
    end
end
endtask 

task mem_fill_random; 
integer i;
integer j;
reg [255:0] val;
begin
    for (j=0; j<16; j=j+1) begin
        for (i=0; i<256; i=i+1) begin
            val[i] = {$random}; 
        end
	    ITOP.io.array[j] = val;
    end
end
endtask

task mem_write;
  input [3:0] addr;
  input [255:0] data;
  begin
     ITOP.io.mem_wr_raw(addr,data);
  end
endtask

function [255:0] mem_read;
  input [3:0] addr;
  begin
	mem_read = ITOP.io.mem_read_raw(addr);
  end
endfunction

task force_rd;
  input [3:0] addr;
  begin
	ITOP.io.r0_dout_tmp = ITOP.io.array[addr];
  end
endtask

`ifdef MEM_PHYS_INFO
task mem_phys_write;
  input [3:0] addr;
  input [255:0] data;
  begin
     ITOP.io.mem_wr_raw(addr,data);
  end
endtask

function [255:0] mem_phys_read_padr;
  input [3:0] addr;
  begin
	mem_phys_read_padr = ITOP.io.mem_read_raw(addr);
  end
endfunction

function [3:0] mem_log_to_phys_adr;
    input [3:0] addr;
    begin
    mem_log_to_phys_adr = addr;
    end
endfunction

function [255:0] mem_phys_read_pmasked;
  input [3:0] addr;
  begin
	mem_phys_read_pmasked = ITOP.io.mem_read_raw(addr);
  end
endfunction

function [255:0] mem_phys_read_ladr;
  input [3:0] addr;
  begin
	mem_phys_read_ladr = mem_phys_read_padr(mem_log_to_phys_adr(addr));
  end
endfunction
`endif //def MEM_PHYS_INFO

`ifdef FAULT_INJECTION
task mem_fault_no_write;
  input [255:0] fault_mask;
   begin
    ITOP.io.mem_fault_no_write(fault_mask);
  end
endtask

task mem_fault_stuck_0;
  input [255:0] fault_mask;
  integer i;
   begin
    ITOP.io.mem_fault_stuck_0(fault_mask);
   end
endtask

task mem_fault_stuck_1;
  input [255:0] fault_mask;
  integer i;
   begin
    ITOP.io.mem_fault_stuck_1(fault_mask);
  end
endtask

task set_bit_fault_stuck_0;
  input r;
  input c;
  integer r;
  integer c;
    ITOP.io.set_bit_fault_stuck_0(r,c);
endtask

task set_bit_fault_stuck_1;
  input r;
  input c;
  integer r;
  integer c;
    ITOP.io.set_bit_fault_stuck_1(r,c);
endtask

task clear_bit_fault_stuck_0;
  input r;
  input c;
  integer r;
  integer c;
    ITOP.io.clear_bit_fault_stuck_0(r,c);
endtask

task clear_bit_fault_stuck_1;
  input r;
  input c;
  integer r;
  integer c;
    ITOP.io.clear_bit_fault_stuck_1(r,c);
endtask
//VCS coverage on

`endif //def FAULT_INJECTION
`else //def SYNTHESIS
    
    wire clobber_x;
    assign clobber_x = 1'b0;
    wire clobber_array = 1'b0;
    wire clobber_flops = 1'b0;

`endif //ndef SYNTHESIS

	//instantiate memory bank
	RAM_BANK_RAMDP_16X256_GL_M1_E2 ITOP (
		.RE(RE), 
		.WE(WE), 
		.RA(RA),  
		.WA(WA), 
		.CLK_R(CLK_R), 
		.CLK_W(CLK_W), 
		.IDDQ(IDDQ), 
		.SVOP(SVOP), 
		.WD(WD), 
		.RD(RD),
		
		.SLEEP_EN(SLEEP_EN),
        .RET_EN(RET_EN),
        .clobber_flops(clobber_flops), 
        .clobber_array(clobber_array),
        .clobber_x(clobber_x)     	
	);

//VCS coverage off
`else //def EMULATION
    // Simple emulation model without MBIST, SCAN or REDUNDANCY
    	//common part for write
    	reg we_ff;
        reg [3:0] wa_ff;
        reg [255:0] wd_ff; 
    	always @(posedge CLK_W) begin // spyglass disable W391
                we_ff  <= WE;
                wa_ff <= WA;
                wd_ff <= WD;
    	end
    	   
        

    	//common part for read
    	reg re_lat;
        always @(*) begin
    		if (!CLK_R) begin
                re_lat  <= RE; // spyglass disable W18
    		end
    	end
    	
    	wire reclk = CLK_R & re_lat;
    
    	reg [3:0] ra_ff;
    	always @(posedge CLK_R) begin // spyglass disable W391
    			ra_ff <= RA;
    	end

        reg [255:0] dout; 

        assign RD = dout;
    
 	    //memory array       
	    reg [255:0] array[0:15]; 
	    always @(negedge CLK_W ) begin
            if (we_ff) begin
	    		array[wa_ff] <= wd_ff; // spyglass disable SYNTH_5130
            end
	    end
	    always @(*) begin
	    	if (reclk) begin
	    		dout <= array[ra_ff]; // spyglass disable SYNTH_5130, W18
	    	end
	    end
    // End of the simple emulation model
`endif //def EMULATION
//VCS coverage on

`endif //ndef RAM_INTERFACE
endmodule
`endcelldefine






/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// memory bank block : defines internal logic of the RAMDP /////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef RAM_INTERFACE
`ifndef EMULATION
module RAM_BANK_RAMDP_16X256_GL_M1_E2 (RE, WE, RA, WA, CLK_R, CLK_W, IDDQ, SVOP, WD, RD, SLEEP_EN, RET_EN, clobber_flops, clobber_array, clobber_x
);


input RET_EN;
input RE, WE, CLK_R, CLK_W, IDDQ;
input [3:0] RA, WA;
input [255:0] WD;
input [1:0] SVOP;
input [7:0] SLEEP_EN;
input clobber_flops, clobber_array, clobber_x;
output [255:0] RD;

//State point clobering signals:

    wire output_valid = ~(clobber_x | (|SLEEP_EN));
    wire clamp_o = SLEEP_EN[7] | RET_EN;

	//common part for write
    wire clk_w_iddq = CLK_W & ~IDDQ & ~clamp_o;
	reg we_lat;
	always @(*) begin
		if (!clk_w_iddq & !clobber_flops) begin
			we_lat  <=  WE; // spyglass disable W18, IntClock
		end
	end

    // weclk with posedge 1 dly | negedge 2 dly	
    wire weclk, weclk_d0, weclk_d1, weclk_d2;
    assign weclk_d0 = clk_w_iddq & we_lat & ~clobber_flops & ~clobber_array;
    assign #1 weclk_d1 = weclk_d0;
    assign #1 weclk_d2 = weclk_d1;
    assign weclk = weclk_d1 | weclk_d2; // spyglass disable GatedClock

    // wadclk with posedge 0 dly | negedge 3 dly	
    wire wadclk, wadclk_d0, wadclk_d1, wadclk_d2, wadclk_d3;
    assign wadclk_d0 = clk_w_iddq & we_lat;
    assign #1 wadclk_d1 = wadclk_d0;
    assign #1 wadclk_d2 = wadclk_d1;
    assign #1 wadclk_d3 = wadclk_d2;
    assign wadclk = wadclk_d0 | wadclk_d1 | wadclk_d2 | wadclk_d3;  

    // wdclk with posedge 0 dly | negedge 3 dly
    wire wdclk, wdclk_d0, wdclk_d1, wdclk_d2, wdclk_d3;
    assign wdclk_d0 = clk_w_iddq & we_lat;
    assign #1 wdclk_d1 = wdclk_d0;
    assign #1 wdclk_d2 = wdclk_d1;
    assign #1 wdclk_d3 = wdclk_d2;
    assign wdclk = wdclk_d0 | wdclk_d1 | wdclk_d2 | wdclk_d3;  

    reg [3:0] wa_lat;
	always @(*) begin
		if (!wadclk & !clobber_flops) begin
			wa_lat  <=  WA; // spyglass disable W18, IntClock
		end
	end

	reg [255:0] wd_lat;
	always @(*) begin
		if (!wdclk & !clobber_flops) begin
			wd_lat  <= WD; // spyglass disable W18, IntClock
		end
	end

	//common part for read
	reg re_lat;
	always @(*) begin
		if (!CLK_R & !clobber_flops) begin
			re_lat <=  RE; // spyglass disable W18, IntClock
		end
	end

    // reclk with posedge 1 dly | negedge 0 dly
    wire reclk, reclk_d0, reclk_d1;
    assign reclk_d0 = CLK_R & ~IDDQ & re_lat & ~clamp_o;
    assign #1 reclk_d1 = reclk_d0;
    assign reclk = reclk_d0 & reclk_d1; // spyglass disable GatedClock

    // radclk with posedge 0 dly | negedge 1 dly
    wire radclk, radclk_d0, radclk_d1;
    assign radclk_d0 = CLK_R & ~IDDQ & re_lat & ~clamp_o;
    assign #1 radclk_d1 = radclk_d0;
    assign radclk = radclk_d0 | radclk_d1;  

	reg [3:0] ra_lat;
	always @(*) begin
		if (!radclk & !clobber_flops) begin
			ra_lat <=  RA; // spyglass disable W18, IntClock
		end
	end
	
	wire [255:0] dout;
	assign RD = clamp_o ? 256'b0 : (output_valid ? dout : 256'bx); //spyglass disable STARC-2.10.1.6


	//for E-option RAM


	vram_RAMDP_16X256_GL_M1_E2 # (16, 256, 4) io (
		.w0_addr(wa_lat),
		.w0_clk(weclk),
		.w0_bwe({256{1'b1}}),
		.w0_din(wd_lat),
		.r0_addr(ra_lat),
		.r0_clk(reclk),
		.r0_dout(dout),
        .clamp_o(clamp_o)
	);

endmodule
`endif //ndef EMULATION
`endif //ndef RAM_INTERFACE








/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////  ram primitive : defines 2D behavioral memory array of the RAMDP ////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef RAM_INTERFACE
`ifndef EMULATION
module vram_RAMDP_16X256_GL_M1_E2 (
	w0_addr,
	w0_clk,
	w0_bwe,
	w0_din,
	r0_addr,
	r0_clk,
	r0_dout,
    clamp_o
);

parameter words = 16;
parameter bits = 256;
parameter addrs = 4;


input [addrs-1:0] w0_addr;
input w0_clk;
input [bits-1:0] w0_din;
input [bits-1:0] w0_bwe;
input [addrs-1:0] r0_addr;
input r0_clk;
input clamp_o;
output [bits-1:0] r0_dout;

integer a;

`ifndef SYNTHESIS
`ifdef FAULT_INJECTION
	// regs for inducing faults
	reg [bits-1:0] fault_no_write; // block writes to this column
	reg [bits-1:0] fault_stuck_0;  // column always reads as 0
	reg [bits-1:0] fault_stuck_1;  // column always reads as 1
	reg [bits-1:0] bit_fault_stuck_0[0:words-1];  // column always reads as 0
	reg [bits-1:0] bit_fault_stuck_1[0:words-1];  // column always reads as 1
	
	initial begin : init_bit_fault_stuck
	  integer i;
	  integer j;
	  fault_no_write = {bits{1'b0}};
	  fault_stuck_0  = {bits{1'b0}};
	  fault_stuck_1  = {bits{1'b0}};
	  for (i=0; i<=words; i=i+1) begin
	      bit_fault_stuck_0[i] = {bits{1'b0}};
	      bit_fault_stuck_1[i] = {bits{1'b0}};
	  end
	end
`endif //def FAULT_INJECTION

`ifdef MONITOR
//VCS coverage off
// monitor variables
reg monitor_on;
reg dump_monitor_result;
// this monitors coverage including redundancy cols
// 1'bx = not accessed
// 1'b0 = accessed as a 0
// 1'b1 = accessed as a 1
// 1'bz = accessed as both 0 and 1
reg [bits-1:0] bit_written[0:words-1];
reg [bits-1:0] bit_read[0:words-1];

initial begin : init_monitor
  monitor_on = 1'b0; 
  dump_monitor_result = 1'b0;
  for(a=0;a<words;a=a+1) begin
      bit_written[a] = {bits{1'bx}};
      bit_read[a] = {bits{1'bx}};
  end
end

always @(dump_monitor_result) begin : dump_monitor
    integer r;
	integer c;
    integer b;
	reg [256-1:0] tmp_row;
    	if (dump_monitor_result == 1'b1) begin
		    $display("Exercised coverage summary:");
		    $display("\t%m bits not written as 0:");
		    for (r=0; r<16; r=r+1) begin
		        tmp_row = bit_written[r];
		    	for (c=0; c<256; c=c+1) begin
		    		if (tmp_row[c] !== 1'b0 && tmp_row[c] !== 1'bz) $display("\t\t[row,col] [%d,%d]", r, c);
		    	end
		    end
            $display("\t%m bits not written as 1:");
		    for (r=0; r<16; r=r+1) begin
		        tmp_row = bit_written[r];
		    	for (c=0; c<256; c=c+1) begin
		    		if (tmp_row[c] !== 1'b1 && tmp_row[c] !== 1'bz) $display("\t\t[row,col] [%d,%d]", r, c);
		    	end
		    end
		    $display("\t%m bits not read as 0:");
		    for (r=0; r<16; r=r+1) begin
		        tmp_row = bit_read[r];
		    	for (c=0; c<256; c=c+1) begin
		    		if (tmp_row[c] !== 1'b0 && tmp_row[c] !== 1'bz) $display("\t\t[row,col] [%d,%d]", r, c);
		    	end
		    end
		    $display("\t%m bits not read as 1:");
		    for (r=0; r<16; r=r+1) begin
		        tmp_row = bit_read[r];
		    	for (c=0; c<256; c=c+1) begin
		    		if (tmp_row[c] !== 1'b1 && tmp_row[c] !== 1'bz) $display("\t\t[row,col] [%d,%d]", r, c);
		    	end
		    end
        end
	dump_monitor_result = 1'b0;
end
//VCS coverage on
`endif //MONITOR
`endif //ndef SYNTHESIS
	
	//memory array
	reg [bits-1:0] array[0:words-1];  

// Bit write enable
`ifndef SYNTHESIS 
    `ifdef FAULT_INJECTION
        wire [bits-1:0] bwe_with_fault = w0_bwe & ~fault_no_write;
        wire [bits-1:0] re_with_fault = ~(bit_fault_stuck_1[r0_addr] | bit_fault_stuck_0[r0_addr]);
    `else
        wire [bits-1:0] bwe_with_fault = w0_bwe;
        wire [bits-1:0] re_with_fault = {bits{1'b1}};
    `endif //def FAULT_INJECTION
`else
    wire [bits-1:0] bwe_with_fault = w0_bwe;
`endif //SYNTHESIS

	//write function
    wire [bits-1:0] bitclk = {bits{w0_clk}} & bwe_with_fault;
    genvar idx;
    generate
        for (idx=0; idx<bits; idx=idx+1)
        begin : write
            always @(bitclk[idx] or w0_clk or w0_addr or w0_din[idx])
            begin
                if (bitclk[idx] && w0_clk)
                begin
                    array[w0_addr][idx] <= w0_din[idx]; // spyglass disable SYNTH_5130, W18
                    `ifndef SYNTHESIS
                    `ifdef MONITOR
//VCS coverage off
                    if (monitor_on) begin 
	    				case (bit_written[w0_addr][idx])
	    				    1'bx: bit_written[w0_addr][idx] = w0_din[idx];
	    				    1'b0: bit_written[w0_addr][idx] = w0_din[idx] == 1 ? 1'bz : 1'b0;
	    				    1'b1: bit_written[w0_addr][idx] = w0_din[idx] == 0 ? 1'bz : 1'b1;
	    				    1'bz: bit_written[w0_addr][idx] = 1'bz;
	    				endcase
                    end   
//VCS coverage on
                    `endif //MONITOR	    
                    `endif //SYNTHESIS	
                end
            end
        end
    endgenerate

	//read function
	wire [bits-1:0] r0_arr;
`ifndef SYNTHESIS
    `ifdef FAULT_INJECTION
	    assign r0_arr = (array[r0_addr] | bit_fault_stuck_1[r0_addr]) & ~bit_fault_stuck_0[r0_addr]; //read fault injection
    `else
	    assign r0_arr = array[r0_addr]; 
    `endif //def FAULT_INJECTION
`else
    assign r0_arr = array[r0_addr]; // spyglass disable SYNTH_5130
`endif //def SYNTHESIS


    wire r0_clk_d0p1, r0_clk_read, r0_clk_reset_collision;
    assign #0.1 r0_clk_d0p1 = r0_clk;
    assign r0_clk_read = r0_clk_d0p1 & r0_clk; // spyglass disable GatedClock
    assign r0_clk_reset_collision = r0_clk | r0_clk_d0p1; // spyglass disable W402b

`ifndef SYNTHESIS
`ifdef MONITOR
//VCS coverage off 
    always @(r0_clk_read) begin
        if (monitor_on) begin
            for (a=0; a<bits; a=a+1) begin
	            if (re_with_fault[a] && r0_clk_read) begin
	                case (bit_read[r0_addr][a])
			            1'bx: bit_read[r0_addr][a] = array[r0_addr][a];
				        1'b0: bit_read[r0_addr][a] = array[r0_addr][a] == 1 ? 1'bz : 1'b0;
				        1'b1: bit_read[r0_addr][a] = array[r0_addr][a] == 0 ? 1'bz : 1'b1;
				        1'bz: bit_read[r0_addr][a] = 1'bz;
		            endcase
	            end
	        end
        end
    end
//VCS coverage on
`endif //MONITOR
`endif //SYNTHESIS

	reg [bits-1:0] collision_ff;
    wire [bits-1:0] collision_ff_clk =  {bits{w0_clk}} & {bits{r0_clk_read}} & {bits{r0_addr==w0_addr}} & bwe_with_fault; //spyglass disable GatedClock
    genvar bw;
    generate
        for (bw=0; bw<bits; bw=bw+1) 
        begin : collision
	        always @(posedge collision_ff_clk[bw] or negedge r0_clk_reset_collision) begin
                if (!r0_clk_reset_collision) 
                    begin
                        collision_ff[bw] <= 1'b0;
                    end
                else
                    begin
                        collision_ff[bw] <= 1'b1;
                    end
            end
        end
    endgenerate

	reg [bits-1:0] r0_dout_tmp;
	always @(*)
	begin
	    if (r0_clk_read) begin
            for (a=0; a<bits; a=a+1) begin
                r0_dout_tmp[a] <= ( collision_ff[a] | (r0_addr==w0_addr & w0_clk & bwe_with_fault[a]) ) ? 1'bx : r0_arr[a] & ~clamp_o; //spyglass disable STARC-2.10.1.6, W18
            end
        end
    end
    wire [bits-1:0] r0_dout = r0_dout_tmp & {bits{~clamp_o}};

`ifndef SYNTHESIS
//VCS coverage off
task mem_wr_raw;
  input [addrs-1:0] addr;
  input [bits-1:0] data;
  begin
    array[addr] = data;
  end
endtask

function [bits-1:0] mem_read_raw;
input [addrs-1:0] addr;
	mem_read_raw = array[addr];
endfunction

`ifdef FAULT_INJECTION
// induce faults on columns
task mem_fault_no_write;
  input [bits-1:0] fault_mask;
   begin
    fault_no_write = fault_mask;
  end
endtask

task mem_fault_stuck_0;
  input [bits-1:0] fault_mask;
  integer i;
   begin
    for ( i=0; i<words; i=i+1 ) begin
      bit_fault_stuck_0[i] = fault_mask;
    end
  end
endtask

task mem_fault_stuck_1;
  input [bits-1:0] fault_mask;
  integer i;
   begin
    for ( i=0; i<words; i=i+1 ) begin
      bit_fault_stuck_1[i] = fault_mask;
    end
  end
endtask

task set_bit_fault_stuck_0;
  input r;
  input c;
  integer r;
  integer c;
  bit_fault_stuck_0[r][c] = 1;
endtask

task set_bit_fault_stuck_1;
  input r;
  input c;
  integer r;
  integer c;
  bit_fault_stuck_1[r][c] = 1;
endtask

task clear_bit_fault_stuck_0;
  input r;
  input c;
  integer r;
  integer c;
  bit_fault_stuck_0[r][c] = 0;
endtask

task clear_bit_fault_stuck_1;
  input r;
  input c;
  integer r;
  integer c;
  bit_fault_stuck_1[r][c] = 0;
endtask
//VCS coverage on
`endif //def FAULT_INJECTION
`endif //ndef SYNTHESIS

endmodule
`endif //ndef EMULATION
`endif //ndef RAM_INTERFACE
