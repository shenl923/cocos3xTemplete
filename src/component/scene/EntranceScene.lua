require "component.scene.BaseScene"
-- "component.scene.EntranceScene"
require "component.BaseCard"

EntranceScene = class("EntranceScene", BaseScene)

EntranceScene.VAR_NEWROUND = 'GAME01.NEWROUND'

function EntranceScene:ctor()
    EntranceScene.super.ctor(self)
end


function EntranceScene:onEnter(...)
    EntranceScene.super.onEnter(self)
    self:checkResUpdate()
end

function EntranceScene:onExit()
    EntranceScene.super.onExit(self)
    if self.am then 
        self.am:release()
    end
end

function EntranceScene:checkResUpdate()
    local function onUpdateEvent(event)
        local eventCode = event:getEventCode()
        if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then
            print("No local manifest file found, skip assets update.")
        elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then 
            local assetId = event:getAssetId()
            local percent = event:getPercent()
            local message = event:getMessage()
            local strInfo = ""
            if assetId == cc.AssetsManagerExStatic.VERSION_ID then 
                strInfo = string.format("Version file: %d%%", percent)
            elseif assetId == cc.AssetsManagerExStatic.MANIFEST_ID then
                strInfo = string.format("Manifest file: %d%%", percent)
            else
                strInfo = string.format("%d%%", event:getPercentByFile())
            end
        elseif eventCode == cc.EventAssetsManagerEx.EventCode.ASSET_UPDATED then 
            print("fileName", event:getAssetId(), event:getPercentByFile())
        elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE or 
            eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then
                print("Update finished.")
        end 
    end

    local sceneManifest = 'assetsManager/project.manifest'
    local storagPath = cc.FileUtils:getInstance():getWritablePath()
    local am = cc.AssetsManagerEx:create(sceneManifest, storagPath)
    am:retain()

    if not am:getLocalManifest():isLoaded() then
        print("Fail to update assets, step skipped.")
    else 
        local listener = cc.EventListenerAssetsManagerEx:create(am,onUpdateEvent)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
        am:update()
    end
    self.am = am
end
