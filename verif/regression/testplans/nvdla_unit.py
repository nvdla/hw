#from testplan import TestPlan
#import TestPlan

#test_plan = TestPlan()
test_plan.load_test_list(os.path.join(test_plan_dir,'test_list.py'))
#print  "nvdla_unit::load following tests"
#test_plan.print_full_test_list()
test_plan.set_test_bench_filter(['nvdla_utb'])
test_plan.update_test_list_by_test_bench()
#print  "nvdla_unit::filter tests by test bench"
#test_plan.print_full_test_list()
test_plan.set_log_checker(
    {
        'nvdla_utb' : '',
    }
)
