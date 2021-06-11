local pcall, dofile, _G = pcall, dofile, _G

-- /etc/openwrt_release ÄÚÈÝ
-- DISTRIB_ID='OpenWrt'
-- DISTRIB_RELEASE='Chaos Calmer'
-- DISTRIB_REVISION='unknown'
-- DISTRIB_CODENAME='chaos_calmer'
-- DISTRIB_TARGET='x86/64'
-- DISTRIB_DESCRIPTION='OpenWrt Chaos Calmer 15.05.1'
-- DISTRIB_TAINTS='no-all glibc'
--
module "luci.version"

if pcall(dofile, "/etc/openwrt_release") and _G.DISTRIB_DESCRIPTION then
	distname    = ""
	distversion = _G.DISTRIB_DESCRIPTION
	if _G.DISTRIB_REVISION then
		distrevision = _G.DISTRIB_REVISION
		if not distversion:find(distrevision,1,true) then
			distversion = distversion .. " " .. distrevision
		end
	end
else
	distname    = "OpenWrt"
	distversion = "Development Snapshot"
end

luciname    = "LuCI Master"
luciversion = "git-17.205.18138-17de308"
