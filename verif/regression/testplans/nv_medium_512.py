test_plan.load_test_list(os.path.join(test_plan_dir,'nvdla_test_list_common.py'))
test_plan.load_test_list(os.path.join(test_plan_dir,'nv_medium_512_test_list_L0.py'))
#test_plan.load_test_list(os.path.join(test_plan_dir,'nv_medium_512_test_list_L1.py'))
#test_plan.load_test_list(os.path.join(test_plan_dir,'nv_medium_512_test_list_L2.py'))
test_plan.load_test_list(os.path.join(test_plan_dir,'nvdla_test_list_L10.py'))
test_plan.load_test_list(os.path.join(test_plan_dir,'nvdla_test_list_L11.py'))
test_plan.load_test_list(os.path.join(test_plan_dir,'nvdla_test_list_L20.py'))
test_plan.load_test_list(os.path.join(test_plan_dir,'nvdla_test_list_L21.py'))
#print  "nvdla_unit::load following tests"
#test_plan.print_full_test_list()
test_plan.set_test_bench_filter(['nvdla_utb'])
test_plan.update_test_list_by_test_bench()
#print  "nvdla_unit::filter tests by test bench"
#test_plan.print_full_test_list()
