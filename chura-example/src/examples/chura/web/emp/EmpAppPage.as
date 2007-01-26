package examples.chura.web.emp {

	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.events.FaultEvent;
	import mx.controls.Alert;
	import flash.events.Event;
	import examples.chura.entity.Emp;
	import examples.chura.web.AbstractPage;
	import examples.chura.web.AppMode;

	[Bindable]
	public class EmpAppPage extends AbstractPage {

		public var empItems: ArrayCollection;
		public var emp: Emp;

		public var appMode: int;

		override public function onCreationComplete(event: Event): void {
			super.onCreationComplete(event);
			setInitEntryMode();
			remoteCall(getEmpItems(), getEmpItemsOnSuccess, getEmpItemsOnFault);
		}
/*
		override public function creationCompleteHandler(): void {
			super.creationCompleteHandler();
			setInitEntryMode();
			remoteCall(getEmpItems(), getEmpItemsOnSuccess, getEmpItemsOnFault);
		}
*/
		
		public function getEmpItems(): AsyncToken {
			return service.getEmpItems();
		}
		
		public function getEmpItemsOnSuccess(ret: ResultEvent, token: Object = null): void {
			empItems = new ArrayCollection(ret.result as Array);
		}
		
		public function getEmpItemsOnFault(ret: FaultEvent, token: Object = null): void {
			Alert.show("empsとれませんでした。。。");
		}
		
		public function beNewOnClick(event: Event): void {
			emp = new Emp();
			setNewEntryMode();
		}
		
		public function beCorOnClick(event: Event): void {
			emp = document.empList.selectedItem;
			setCorEntryMode();
		}
		
		public function cancelOnClick(event: Event): void {
			setInitEntryMode();
		}

		public function insertOnClick(event: Event): void {
			setFormData();
			remoteCall(insertEmp(), insertEmpOnSuccess, insertEmpOnFault);
		}

		public function insertEmp(): AsyncToken {
			return service.insert(emp);
		}
		
		public function insertEmpOnSuccess(ret: ResultEvent, token: Object = null): void {
			setInitEntryMode();
			remoteCall(getEmpItems(), getEmpItemsOnSuccess, getEmpItemsOnFault);
		}
		
		public function insertEmpOnFault(ret: FaultEvent, token: Object = null): void {
			Alert.show("insertに失敗しました。");
			setInitEntryMode();
		}
		
		public function updateOnClick(event: Event): void {
			setFormData();
			remoteCall(updateEmp(), updateEmpOnSuccess, updateEmpOnFault);
		}
		
		public function updateEmp(): AsyncToken {
			return service.update(emp);
		}
		
		public function updateEmpOnSuccess(ret: ResultEvent, token: Object = null): void {
			setInitEntryMode();
			remoteCall(getEmpItems(), getEmpItemsOnSuccess, getEmpItemsOnFault);
		}
		
		public function updateEmpOnFault(ret: FaultEvent, token: Object = null): void {
			Alert.show("updateに失敗しました。");
			setInitEntryMode();
		}
		
		public function removeOnClick(event: Event): void {
			emp = document.empList.selectedItem;
			remoteCall(removeEmp(), removeEmpOnSuccess, removeEmpOnFault);
		}
		
		public function removeEmp(): AsyncToken {
			return service.remove(emp);
		}
		
		public function removeEmpOnSuccess(ret: ResultEvent, token: Object = null): void {
			remoteCall(getEmpItems(), getEmpItemsOnSuccess, getEmpItemsOnFault);
			setInitEntryMode();
		}
		
		public function removeEmpOnFault(ret: FaultEvent, token: Object = null): void {
			Alert.show("deleteに失敗しました。");
			setInitEntryMode();
		}
		
		public function setFormData(): void {
			loadFormData(this.emp);
		}
		
		public function setInitEntryMode(): void {
			appMode = AppMode.NEUTRAL;
			emp = null;
		}
		
		public function setNewEntryMode(): void {
			appMode = AppMode.NEW;
		}

		public function setCorEntryMode(): void {
			appMode = AppMode.COR;
		}
	}
}